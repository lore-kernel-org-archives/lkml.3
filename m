Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3BFECA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:02:00 -0500
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:22571
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755183Ab3BFEB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:01:57 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Wed, 6 Feb 2013 12:02:14 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arm@kernel.org>, Liam Girdwood <lrg@ti.com>,
        <alsa-devel@alsa-project.org>
Subject: Re: [PATCH] ASoC: fsl: fix allyesconfig build for imx-pcm
Message-ID: <20130206040212.GA18613@S2101-09.ap.freescale.net>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <20130122063331.GA1766@opensource.wolfsonmicro.com>
 <201302051621.12320.arnd@arndb.de>
 <201302051642.25361.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <201302051642.25361.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2013 at 04:42:25PM +0000, Arnd Bergmann wrote:
> Patch 25b8d314 "ASoC: fsl: fix multiple definition of init_module changed
> the Makefile for imx-pcm.ko to build two modules that both contain the
> imx-pcm.c file, which nicely solves the problem of building both versions
> of the driver as modules, but it causes two new problems:
> 
It's my fault, Arnd.  The patch 25b8d314 is a crap.  Instead of making
the Kconfig even complexer, I chose to revert the patch and do a little
surgery on the code to make it match the Kconfig rational.  The fix[1]
should be on the way to mainline now.

I'm sorry for messing thing up during -rc time.

Shawn

[1] http://thread.gmane.org/gmane.linux.alsa.devel/105018

