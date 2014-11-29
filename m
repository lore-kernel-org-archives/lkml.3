Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaK2BxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 20:53:13 -0500
Received: from s72.web-hosting.com ([198.187.29.22]:51619 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaK2BxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 20:53:12 -0500
X-Greylist: delayed 2919 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Nov 2014 20:53:12 EST
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <21625.7161.847488.931468@gargle.gargle.HOWL>
Date: Sat, 29 Nov 2014 06:36:01 +0530
To: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Cc: <linux-kernel@vger.kernel.org>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: ath: phy1: DMA failed to stop in 10 ms
In-Reply-To: <20141129015934.1d2925d5@bigpc>
References: <20141129015934.1d2925d5@bigpc>
X-Mailer: VM 8.2.0b under 25.0.50.1 (x86_64-unknown-linux-gnu)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server72.web-hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - msujith.org
X-Get-Message-Sender-Via: server72.web-hosting.com: authenticated_id: sujith@msujith.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrej Gelenberg wrote:
> i got some problems with my Qualcomm Atheros AR9485 wlan pcie card. I
> use my card as access point (with hotspotd) on amd64 machine. I use
> self compiled vanilla kernel 3.17.4 and a get a lot of 
> "DMA failed to stop" messages in my kernel log. I found some reports on
> similar errors for *wrt, ubuntu and other distros in various
> operation modes (ap and client). Increasing the timeout in mac.c to 100
> ms do not help. iommu=soft do not help either and GART iommu is not an
> option (usb don't work for me with amd_iommu=off). I found this patch:
> https://dev.openwrt.org/browser/trunk/package/mac80211/patches/552-ath9k_rx_dma_stop_check.patch?rev=34910 ,
> which seems to apply to my problem, but i am not sure if it is a proper
> solution.

Can you please open a bug on bugzilla.kernel.org ?

Sujith
