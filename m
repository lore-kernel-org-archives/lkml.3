Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3KFKPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 05:15:37 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41324 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab3KFKPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 05:15:34 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbLTopHMaog7FDW7O4-yLyv+mmnvgkNuXgeQR-pEtbz6Q@mail.gmail.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
 <1383406775-14902-2-git-send-email-prabhakar.csenng@gmail.com>
 <CACRpkdZ7pwGQnK0NN4tybLUNdMxu5WVaGX8Dqu+kMgVBuyF16w@mail.gmail.com>
 <CA+V-a8tE3bxsHMSh2i3Xeq=kJUjmxTjcU25Kuka5e_iXeB--pQ@mail.gmail.com> <CACRpkdbLTopHMaog7FDW7O4-yLyv+mmnvgkNuXgeQR-pEtbz6Q@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 6 Nov 2013 15:45:13 +0530
Message-ID: <CA+V-a8tZTm9bh+arQ+uFyTVHxfdf07bWaM_Sdqo08TO=UCMMUg@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] gpio: davinci: Fixed a check for unbanked gpio
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sekhar Nori <nsekhar@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Alex Elder <alex.elder@linaro.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Nov 6, 2013 at 3:26 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Nov 6, 2013 at 10:33 AM, Prabhakar Lad
> <prabhakar.csengg@gmail.com> wrote:
>> On Tue, Nov 5, 2013 at 6:09 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Sat, Nov 2, 2013 at 4:39 PM, Lad, Prabhakar
>>> <prabhakar.csengg@gmail.com> wrote:
>>>
>>>> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
>>>>
>>>> This patch fixes the check for the offset in
>>>> gpio_to_irq_unbanked() function.
>>>>
>>>> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> Is this a regression that should go in right now?
>>>
>> Yes it needs too.
>
> But on top of *what* exactly?
>
> This does not apply to my gpio tree devel branch and
> not even on the mainline kernel.
>
Looks like this needs to go via ARM tree as the earlier
patches have  gone via ARM tree itself [1].
If you can ACK it Sekhar can get it in via ARM tree.

> Is this something that should go on top of the davinci
> GPIO patch set that is still being elaborated on?
>
Nope.

[1]  http://www.spinics.net/lists/arm-kernel/msg275267.html

Regards,
--Prabhakar Lad
