Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263Ab3HIO0j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:26:39 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:62317 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab3HIO0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:26:36 -0400
Date: Fri, 9 Aug 2013 16:26:34 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: "Koul, Vinod" <vinod.koul@intel.com>
cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: my outstanding patches for 3.12
Message-ID: <Pine.LNX.4.64.1308091531040.937@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:kgJwvSTURuoOcz2PH9LUlnBm5Hhl7fgb7amrDbxppim
 XTaePU1Oikc49qN1/y6A/tIY5IG2+doxjC2Is2fVxn8l4Q44Jo
 viPiMJaS87EvZNTPpAzpc7rydXlww5u58OBFyEK9tEQa099m1d
 hp8DUGamtpYWyWWrhsYl2BakNdq3ucut0E9MNtDVMFscLPLUBx
 sM71xAqMSaWoQ0jEDhyQaOi08gWhX6Z1xKdzIwri5159G0V/O/
 8RfX5YGDpBw8PN2jp+0UiKuQwOwDDhp25VzT70CUNmJ6IQEgFY
 RKzi6cwhZmItYzhPJtQ476II7RtHhtvIDtVxGcb78vOBknAcgj
 cFmQuTjxppQjTnt1qcPP98xZh+XdTfCGDY6h2WwOhSv+hN5Mh6
 OH/Oi5CG2boiw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

There are still a number of DMA patches from me for 3.12, that still 
aren't in next. I think, the easiest way to get them all is to look for 
instructions in patch 0/0 from this series:

http://thread.gmane.org/gmane.linux.ports.sh.devel/26161

Otherwise, unless I'm missing anything, here's the list of single patches 
with their respective patchwork IDs - it includes two more patches, not 
mentiones at the above link:

DMA: shdma: fix CHCLR register address calculation
pw ID: 2813531

DMA: shdma: switch to managed resource allocation
pw ID: 2813591

DMA: shdma: switch all __iomem pointers to void
pw ID: 2813611

DMA: shdma: support the new CHCLR register layout
pw ID: 2825593

DMA: shdma: make a pointer const
pw ID: 2837949

DMA: sudmac: fix compiler warning
pw ID: 2837890

DMA: shdma: move two macros to a header
pw ID: 2831934

DMA: shdma: switch DT mode to use configuration data from a match table
pw ID: 2837974

DMA: shdma: remove private and unused defines from a global header
pw ID: 2837962

DMA: shdma: add a header with common for ARM SoCs defines
pw ID: 2837964

DMA: shdma: add r8a73a4 DMAC data to the device ID table
pw ID: 2837967

As I mentioned in a separate mail, I'm mostly offline for the next two 
weeks, hopefully, there won't be problems with these patches.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
