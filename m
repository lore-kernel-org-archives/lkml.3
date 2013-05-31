Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab3EaVYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 17:24:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:50872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab3EaVYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 17:24:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [PATCH 2/2] spi: convert drivers to use bits_per_word_mask
Date: Fri, 31 May 2013 23:23:33 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org,
        Mike Frysinger <vapier@gentoo.org>
References: <1369190195-14598-1-git-send-email-swarren@wwwdotorg.org> <1528437.8btZmmDHhd@wuerfel> <51A8CB87.80201@wwwdotorg.org>
In-Reply-To: <51A8CB87.80201@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201305312323.33706.arnd@arndb.de>
X-Provags-ID: V02:K0:g3cIv5lr5uzVKjloarDp2F3LFcf1Q/AfSBN2zrgF+Em
 3vZaEUuXqHGKc9ZgVoj6NZ1ZGY+82KxCxO2sgH1PkBC38Wbtg5
 TxuSFvgS0myTuclUPcp0Ql1U1Hbwo3Y14LvBfgNHq+ly7HsZmq
 h4AhCvvlh1NukK+4AzZrF1AaX3rN8VHsEzIQnT/tg52xEMvx55
 r+8cqPmlW6snbjnvQAw0iTyNEuwEuYcmcrgd6Vde1x6+hYBqQT
 T/L/ljZp/MNorT8Sk3+x2reNTC6ikAgcXc5V02QCIvJpvex4o2
 +/HnMZTHpMT1hV/fuipkqAvu+vKfFc/2rsipJMxA1LY+RntYue
 YHizNZJGXnjVto1FyaE4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 May 2013, Stephen Warren wrote:
> > drivers/spi/spi-pxa2xx.c: In function 'pxa2xx_spi_probe':
> > drivers/spi/spi-pxa2xx.c:1152:3: warning: left shift count >= width of type [enabled by default]
> >    master->bits_per_word_mask = SPI_BPW_RANGE_MASK(4, 32);
> >    ^
> 
> That should be fixed by the patches I sent yesterday.

Cool, thanks!

	Arnd
