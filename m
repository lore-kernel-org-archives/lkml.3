Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3GBPp4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 11:45:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60191 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab3GBPpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 11:45:55 -0400
Date: Tue, 2 Jul 2013 17:45:49 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: linux-sh@vger.kernel.org
cc: "Koul, Vinod" <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: [PATCH 0/3] DMA: shdma: several stylistic improvements and support
 for new SoCs
Message-ID: <Pine.LNX.4.64.1307021738500.1965@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:x/VXqHWFsMGGYLWNBaNxcNRT6E8wxZKPT9m70+Wj6EX
 LXFvNw6yDlC9lpcz53uCtKor60SC15z0EkdRZvV3wdrYOC2taa
 avL+HG6Aa9f7+BVx+N6fjb6pqBW4ksgUYoZMJXQSLcgQ0Ecmkc
 N6yTMBGhbLr9HgjihQvc2MZjb38YnTQBek12sMQUNfqX04Y2fP
 jbafCcREY7wK2q2dcq8C0ICDdAprWXde3sv4X0LgLzKTPSHxgQ
 GRh83cKM0MiSyTkOPkUS6H+dZzyludjeMprV87H08Lko6KcOdP
 IoWFoYQrjTI19hxqqm2XUJoPEoPbfhxsOTSu8eKGinV/+5iu8g
 SK6Ll73HUTHe09MrEutGkW6Mp/8vIECPZYozndZB6cGiPIMUdr
 uM6SXS3D8lO3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

The first two patches in this small series improve driver internals a bit 
by using preferred APIs, the 3rd patch adds support for new DMAC versions, 
present on AG5, APE6, H2.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

