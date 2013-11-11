Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754349Ab3KKPkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:40:05 -0500
Received: from mail-we0-f182.google.com ([74.125.82.182]:53819 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3KKPj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:39:56 -0500
MIME-Version: 1.0
In-Reply-To: <527D05BA.3000008@ti.com>
References: <1383905510-31760-1-git-send-email-prabhakar.csengg@gmail.com>
 <1383905510-31760-2-git-send-email-prabhakar.csengg@gmail.com> <527D05BA.3000008@ti.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Mon, 11 Nov 2013 21:09:34 +0530
Message-ID: <CA+V-a8tD0NVEij6qXZ6iYe96QwpvTKjcmdBv0S4qzwRkCzDtjw@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] gpio: davinci: remove unnecessary printk
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Sekhar Nori <nsekhar@ti.com>, Linus Walleij <linus.walleij@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LDOC <linux-doc@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,

Thanks for the review.

On Fri, Nov 8, 2013 at 9:09 PM, Grygorii Strashko
<grygorii.strashko@ti.com> wrote:
> On 11/08/2013 12:11 PM, Prabhakar Lad wrote:
>>
>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>
>> the devm_*() helper prints error messages in case of
>> errors no need to do the same in the driver.
>
>
> Pls, drop it - devm_clk_get() doesn't always print error messages
>
OK will drop in the next version.

Regards,
--Prabhakar Lad
