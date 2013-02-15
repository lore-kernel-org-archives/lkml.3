Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161696Ab3BOMz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:55:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63976 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161416Ab3BOMzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:55:53 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH 5/9] ARM: shmobile: mark mackerel sh_mmcif_device __maybe_unused
Date: Fri, 15 Feb 2013 12:55:06 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Simon Horman <horms+renesas@verge.net.au>
References: <1360880818-4071454-1-git-send-email-arnd@arndb.de> <1360880818-4071454-6-git-send-email-arnd@arndb.de> <20130214232426.GB30667@verge.net.au>
In-Reply-To: <20130214232426.GB30667@verge.net.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201302151255.06547.arnd@arndb.de>
X-Provags-ID: V02:K0:NIRO2jesqm4h2oqp8PVFHM3FWe7py9Jmqy0qoQPvZEV
 TFdQrx2aEUrUVkuSN3G3prsrQnFyRTwNi1vvb0Oebq18c/2CEf
 CREOqXygrTEBkmYKAGB9m752yxb7x9ZL8pBz7etziz0zl5NZG1
 FTwSCvHc7X9xAyj5A/iQShkwdCdBE/DD939HBQWSoz2U6hmOwD
 szRYSe08ffQEqYcmf8+7kQub4T5BrhJ7XqboUteZV8kxW1YbxJ
 Th0upWSM0zxU34K2g7LcJIjfH8jQJAlmW3N495+hwnaTdEXNAd
 UqAbLqvR1b4X4biKc56kuPuT6nbh+IWaCig0NsXnSg8Jvz5nOc
 kOCfUnSuWFJ3fWOpVdmw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 February 2013, Simon Horman wrote:
> On Thu, Feb 14, 2013 at 11:26:54PM +0100, Arnd Bergmann wrote:
> > Patch eac036ef9e "ARM: shmobile: streamline mackerel SD and MMC devices"
> > made the use of the sh_mmcif_device variable for mackarel optional,
> > but the definition is always provided, causing a build warning.
> > 
> > arch/arm/mach-shmobile/board-mackerel.c:1120:31: warning: 'sh_mmcif_device'
> > 	defined but not used [-Wunused-variable]
> > 
> > Marking the variable as __maybe_unused will do the right thing here.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> > Cc: Simon Horman <horms+renesas@verge.net.au>
> 
> No objections here.
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

AFAICT, the change that caused this is in linux-next only through your
heads/boards3 branch but not through arm-soc, so please apply my patch
on your branch.

	Arnd
