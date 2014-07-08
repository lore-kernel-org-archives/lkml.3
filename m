Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaGHIbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:31:25 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:64710 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbaGHIbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:31:22 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdaRReCWObTBP-ujiM-R9Js2y+L6RFtAfw6AP1cwx1hrHA@mail.gmail.com>
References: <1404193516-4384-1-git-send-email-acourbot@nvidia.com>
 <1404193516-4384-3-git-send-email-acourbot@nvidia.com> <CACRpkdaRReCWObTBP-ujiM-R9Js2y+L6RFtAfw6AP1cwx1hrHA@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 8 Jul 2014 17:31:01 +0900
Message-ID: <CAAVeFuKrvvmWGS0OaP+JBmozT70K9=0ntL7Zx+vZPBjr2H8aDg@mail.gmail.com>
Subject: Re: [RFC 2/3] gpio: move sysfs support to its own file
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 5:21 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jul 1, 2014 at 7:45 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>
>> sysfs support is currently entangled within the core GPIO support, while
>> it should relly just be a (privileged) user of the integer GPIO API.
>> This patch is a first step towards making the gpiolib code more readable
>> by splitting it into logical parts.
>>
>> Move all sysfs support to their own source file, and share static
>> members of gpiolib that need to be in the private gpiolib.h file. In
>> the future we will want to put some of them back into gpiolib.c, but this
>> first patch let us at least identify them.
>>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>
> Patch applied. We really need to make refactorings like this
> so thanks a lot.

Excellent, glad you approve of this. I actually have some more coming
after that, since the current lack of organization stands in the way
of a proper multi-consumer GPIO implementation.

Thanks!
Alex.
