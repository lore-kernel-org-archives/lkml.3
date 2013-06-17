Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013Ab3FQQOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:14:22 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:63630 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab3FQQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:14:21 -0400
MIME-Version: 1.0
In-Reply-To: <1371446435.2776.122@driftwood>
References: <1371377909-5921-1-git-send-email-linus.walleij@stericsson.com>
	<1371446435.2776.122@driftwood>
Date: Mon, 17 Jun 2013 18:14:20 +0200
Message-ID: <CACRpkdZdPR-hrV_dRpochwZsM_E1SMZoSXFM9-MN_3Ko6Aa2cw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: update GPIO range doc
From: Linus Walleij <linus.walleij@linaro.org>
To: Rob Landley <rob@landley.net>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Christian Ruppert <christian.ruppert@abilis.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 17, 2013 at 7:20 AM, Rob Landley <rob@landley.net> wrote:
> On 06/16/2013 05:18:29 AM, Linus Walleij wrote:
>>
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This updates the GPIO range documentation with the API changes
>> for sparse/random/arbitrary pin-to-GPIO mappings.
>
> Acked-by: Rob Landley <rob@landley.net>
>
> Why isn't this part of the pinctrl series you posted right afterwards? (It
> should go in through that maintainer...)

Well I'm the pinctrl maintainer so I keep it all in my head :-D

>> +in gpio number, and use the ranges internals to retrive a pin number.
>> After
>
> Range's perhaps?

Thanks, fixed it up.

Yours,
Linus Walleij
