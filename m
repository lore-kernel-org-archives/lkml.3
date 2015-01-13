Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752409AbbAMNVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:21:07 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:54578 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbbAMNVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:21:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kernel-build-reports@lists.linaro.org
Cc: Mark Brown <broonie@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Vinod Koul <vinod.koul@intel.com>, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: -next build failures in k3dma.c
Date: Tue, 13 Jan 2015 14:20:31 +0100
Message-ID: <2546132.YsPQSK8ktD@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20150113120751.GQ4160@sirena.org.uk>
References: <E1YAwSG-0000zm-Cs@debutante> <20150113120751.GQ4160@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:f3ta+3+N45Ax07bX8dxTeIFCRNnZ+lMzrjhPRPwGD9r8iffaYEe
 ekvki/KxubrJaXdcW7nDflQ8x6pguBPsMH85g60WX1+QaNuQKjpRsyxnVx8bQWrgEb9ZSRK
 LU+OesPfMvL9ChFBlm7rMZUdhzR8BhLXwIw2xCyxTOltSDNpprMv4p94rQb27QxDKeMDp6Q
 bJIjAW2HrGyJS0FFjpzuw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 January 2015 12:07:51 Mark Brown wrote:
> On Tue, Jan 13, 2015 at 08:04:00AM +0000, Build bot for Mark Brown wrote:
> 
> > 	arm-allmodconfig
> > ../drivers/dma/k3dma.c:823:12: error: conflicting types for 'k3_dma_resume'
> 
> For several days now k3dma.c has been failing to build in an ARM
> allmodconfig because the definition of k3_dma_resume() introduced in
> db08425ebd51f (dmaengine: k3: Split device_control) taking a struct
> dma_chan * conflicts with that which has been in the file since it was
> originally merged taking a struct device *.

Incidentally, I've restarted by randconfig build testing today, will follow
up with my fix.

	Arnd
