Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbaBYKN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 05:13:59 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.106]:36374 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaBYKNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 05:13:55 -0500
X-Env-Sender: anthony.olech.opensource@diasemi.com
X-Msg-Ref: server-6.tower-194.messagelabs.com!1393323232!12165402!1
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Lee Jones <lee.jones@linaro.org>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
Thread-Topic: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
Thread-Index: AQHPLZDX9akHewh6rEGluUrpgLLvi5rFs/aAgAALD5A=
Date: Tue, 25 Feb 2014 10:13:52 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51BCFDB5D2@NB-EX-MBX02.diasemi.com>
References: <201402191637.s1JGb45N017694@swsrvapps-02.lan>
 <20140225085701.GD19099@lee--X1>
In-Reply-To: <20140225085701.GD19099@lee--X1>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.24.126]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s1PAECtF021688

> -----Original Message-----
> From: Lee Jones [mailto:lee.jones@linaro.org]
> Sent: 25 February 2014 08:57
> To: Opensource [Anthony Olech]
> Cc: Samuel Ortiz; Liam Girdwood; linux-kernel@vger.kernel.org; Mark
> Brown; David Dajun Chen
> Subject: Re: [PATCH V1 2/3] MFD: da9052: Add new DA9053 BC chip variant
> > Add support for a new BC variant of the DA9053 PMIC.
> > There is one difference between it and the AA, BA and BB.
> > This patch also corrects a typing mistake in one of the BA name
> > strings that was incorrectly typed as "ab".
> > Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> > ---
> >
> > This patch is relative to linux-next repository tag next-20140219
> 
> That's not generally a good idea.
> Please use a Mainline version (inc. -rcs).

Hi Lee,

thanks for applying the patch.

I can rebase against any tagged version in a public git repository, but in the past
I was advised to use linux-next instead of the mainline. At this moment in time
the latest tag in git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
is 'v3.14-rc4'

Are you recommending that tag as the one to rebase (and test of course) against?

many thanks
Tony Olech

> > This patch depends on patch number 1 of this patch series being
> > applied first or it will not compile.
> >
> >  drivers/mfd/da9052-i2c.c |    5 ++++-
> >  drivers/mfd/da9052-spi.c |    1 +
> >  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> Applied, thanks.
> 
> --
> Lee Jones
> Linaro STMicroelectronics Landing Team Lead Linaro.org â”‚ Open source
> software for ARM SoCs Follow Linaro: Facebook | Twitter | Blog
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
