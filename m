Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab3DVMid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:38:33 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53350 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab3DVMic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:38:32 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 2/2] dma: of: Remove check on always true condition
Date: Mon, 22 Apr 2013 14:38:29 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: Vinod Koul <vinod.koul@intel.com>, Jon Hunter <jon-hunter@ti.com>,
        linux-kernel@vger.kernel.org
References: <1366619613-30639-1-git-send-email-lars@metafoo.de> <1366619613-30639-2-git-send-email-lars@metafoo.de>
In-Reply-To: <1366619613-30639-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304221438.29857.arnd@arndb.de>
X-Provags-ID: V02:K0:n4gQjLQnis3h5LFR+cvs6D5WJXgD6Hc3n9HvuztxMqL
 dQGxdaE0bjdlhPP1SFIstLRNa0Ec48xKlxsanDkthKIMzEP8nT
 Vo7o2p1FyqwkJkq6PW77eOalhGEFiIMI5TtzVnxOl52MhLRvRm
 Qpk/0IIM3jyrtDhEAVvfjZrrVsVsMLexEbXsAIpNJNBv8w/7zP
 nCIwpwsdPA986uUnAXPMZRIu6pFq5ZdEnkkE/UyLVEpWslF/E5
 GFCGLjiNdbcp+4w93pV9QcWEtic/JLQzzRm3qaM6ESXM+eaU0+
 aSGeUHkG15IzQr2+jJal0BVRnX696kBDFEjDLhJOk28cNKZuJl
 P3paDdqMy+RuQqfA+mJI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 April 2013, Lars-Peter Clausen wrote:
> Both of_dma_nbcells field of the of_dma_controller and the args_count field of
> the dma_spec are initialized by parsing the #dma-cells attribute of their device
> tree node. So if the device tree nodes of a DMA controller and the dma_spec
> match this means that of_dma_nbcells and args_count will also match. So the
> second test in the of_dma_find_controller loop is redundant because given the
> first test yields true the second test will also yield true. So we can safely
> remove the test whether of_dma_nbcells matches args_count. Since this was the
> last user of the of_dma_nbcells field we can remove it altogether.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---

Acked-by: Arnd Bergmann <arnd@arndb.de>
