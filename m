Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644Ab3FRNIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:08:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51417 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab3FRNIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:08:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joel A Fernandes <joelagnel@ti.com>
Subject: Re: [PATCH v11 0/8] ] DMA Engine support for AM33XX
Date: Tue, 18 Jun 2013 15:07:40 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>
References: <1371537499-12970-1-git-send-email-joelagnel@ti.com>
In-Reply-To: <1371537499-12970-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201306181507.40849.arnd@arndb.de>
X-Provags-ID: V02:K0:9gs1Y7kyF/Q8LkUe7+zegPKhE5XA8D63vK9lrcqkuH6
 iws3YHXXyn2Cb7fTrk7r2vt72b4mdjUGNgDti+yo4Dcg+pJKZx
 zHLnAcY705kbVJ83Cj1B+G6EjuiEiRAkUezfLdf/9LSYla0Zre
 yJVmJLH18hc9V0Uj7/j9Iz5YmaOlqUqw1Jx7+i7pih36h3lT9D
 JB6+hKolnOZrDBKJ9Orv4DehBiURU56ELLvAVgiO5c74gNuajQ
 Q8goCuQo9PTMyAi30ix95XS/5Ygp4cmE0CBhF56GBQSSiE4KVs
 MWA49vR8ibchMg59wIKe1ROrcQbuQA1n5zbD3FyYMcBRsxvuyH
 BwVixWHvrAn1Jqnu9tCA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 June 2013, Joel A Fernandes wrote:
> 
> This series is a repost of Matt Porter's EDMA patches for AM33XX EDMA support
> with changes for few pending review comments on v9 series.
> 
> Currently this is required for AM33XX (Beaglebone or EVM) to access MMC
> and be able mount to rootfs and boot till command prompt over MMC.
> Unless there are other pending review comments, I hope this series can
> make it into 3.11 merge window, the dependent series has been posted at [1]
> and completed review.
> 
> Tested EDMA on AM1808 EVM and AM33XX Beaglebone with MMC.
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>

The binding looks good now.

My usual comment about the fact that we shouldn't use a filter function in
.xlate() applies here, but that is more about the missing interface of
the dmaengine layer than the particular driver.

	Arnd
