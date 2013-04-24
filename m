Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab3DXMwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:52:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:53030 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837Ab3DXMwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:52:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH] ASoC: don't call of_dma_request_slave_channel directly
Date: Wed, 24 Apr 2013 14:52:10 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, "Lars-Peter Clausen" <lars@metafoo.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1366732475-479886-1-git-send-email-arnd@arndb.de> <1366732475-479886-3-git-send-email-arnd@arndb.de> <20130424011153.GA2319@shlinux1.ap.freescale.net>
In-Reply-To: <20130424011153.GA2319@shlinux1.ap.freescale.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304241452.10298.arnd@arndb.de>
X-Provags-ID: V02:K0:/7oQvAACg1RrMOckWL9IQQZoiZhu7cSYThVeyRL8RsP
 zd6q6e6i4Gj2xhdHU5ZS3qYdUQprm4ERk2vZPAkpsQCOjtOiPR
 Dwl20ljOrEeD/8kOhBBWWoCz/BO5PkBeAjTu/Dp+mZNNHEPmha
 6P69p5A18PkJkTzj2Fd2wE6jfJH6NbrCkuFcy4qdbWMhK3YP7i
 b5IVTNQtXs507xnG24Z1AVP0iq57zRQH9dGpjH/gOPRtfygXXO
 9Yx6w5hbBOpQohh2yOTcVTGhZC3x1CYd+Mglkxq3KoFnI9gsM1
 vpYKQxuyNEVPiSYqPHIP8knONM3kSnIM8NF/dPRAN5gO7MOemS
 2iPEJwG2Vwo22birWqiM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 April 2013, Shawn Guo wrote:
> On Tue, Apr 23, 2013 at 05:54:33PM +0200, Arnd Bergmann wrote:
> > The exported interface for device drivers is dma_request_slave_channel,
> > not of_dma_request_slave_channel. The former does not depend on device
> > tree but also works with ACPI and other interfaces providing an
> > abstraction for DMA channels.
> > 
> > This fixes link errors when building ALSA as a loadable module.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> I had already sent a similar patch [1] for that.
> 

Yes, I see it in linux-next now.

Thanks,

	Arnd
