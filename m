Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab3KFLgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:36:09 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35425 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3KFLgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:36:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+V-a8tZTm9bh+arQ+uFyTVHxfdf07bWaM_Sdqo08TO=UCMMUg@mail.gmail.com>
References: <1383406775-14902-1-git-send-email-prabhakar.csenng@gmail.com>
	<1383406775-14902-2-git-send-email-prabhakar.csenng@gmail.com>
	<CACRpkdZ7pwGQnK0NN4tybLUNdMxu5WVaGX8Dqu+kMgVBuyF16w@mail.gmail.com>
	<CA+V-a8tE3bxsHMSh2i3Xeq=kJUjmxTjcU25Kuka5e_iXeB--pQ@mail.gmail.com>
	<CACRpkdbLTopHMaog7FDW7O4-yLyv+mmnvgkNuXgeQR-pEtbz6Q@mail.gmail.com>
	<CA+V-a8tZTm9bh+arQ+uFyTVHxfdf07bWaM_Sdqo08TO=UCMMUg@mail.gmail.com>
Date: Wed, 6 Nov 2013 12:36:03 +0100
Message-ID: <CACRpkdYa4aKh+-h2CVJ6H2xZihcFzkh2zqjRbLRrw273t=SVrQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/6] gpio: davinci: Fixed a check for unbanked gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
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

On Wed, Nov 6, 2013 at 11:15 AM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> On Wed, Nov 6, 2013 at 3:26 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> This does not apply to my gpio tree devel branch and
>> not even on the mainline kernel.
>>
> Looks like this needs to go via ARM tree as the earlier
> patches have  gone via ARM tree itself [1].
> If you can ACK it Sekhar can get it in via ARM tree.

Aha OK.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
