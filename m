Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab3AVIVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:21:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3AVIVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:21:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 05/15] ASoC: fsl: fiq and dma cannot both be modules
Date: Tue, 22 Jan 2013 08:21:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <20130122035028.GB29677@S2100-06.ap.freescale.net> <20130122063331.GA1766@opensource.wolfsonmicro.com>
In-Reply-To: <20130122063331.GA1766@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301220821.05252.arnd@arndb.de>
X-Provags-ID: V02:K0:G7jIRJtMLmfX0w13HTGDql06w/RzY4RRRZ1gsuih7u6
 KMv723/xe0+vTlXDElpndjFeJBh/sJPkEr7zlMFMPFuwa4Adie
 AiZ/lvZ1d2hU0swgQmrB3JsV1Nt1Nc2f60a69ri0zDIkl7AK/t
 Xm6b6/grAjxxWZl9iitLfffzsuWYmlUbHk7yZscUlAJExwpV4p
 DsY9a2cinJg49RCMFb+NCklx/DA0gXEsbq3G4nIny9LhwIk9Qk
 CfxiRskFQPkPNIbw2+6/MjJhYqlMkNI5N8HfAoM/CDE+lcpkaV
 WKTwot1J8NhXFtW8zllMT0s6LDFf+13R+MRePQWk0UIST1w2zh
 +RZ9cNPXtrVCkMe8r28o=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 January 2013, Mark Brown wrote:
> On Tue, Jan 22, 2013 at 11:50:30AM +0800, Shawn Guo wrote:
> > I sent a fix [1] for that queued by Mark.

Right, that patch looks good, too.

> > Is the patch on the way to 3.8-rc?
> 
> Yes, should be.

Ok, thanks!

	Arnd
