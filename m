Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaHAM4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:56:06 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:55731 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbaHAM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:56:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@gmail.com>
Subject: Re: [PATCH v2] dma-mapping: Provide write-combine allocations
Date: Fri, 1 Aug 2014 14:55:18 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-35-generic; KDE/4.3.2; x86_64; ; )
Cc: Russell King <linux@arm.linux.org.uk>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1403863018-20033-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201408011455.18991.arnd@arndb.de>
X-Provags-ID: V02:K0:AbFcwwLoB6JuMQnzjpQtaE+ClcVH3IaqS5Qm4PQMbIh
 cMTClT7UdFjeXj77N59IYVjrsP/PXX/cUcofpz6f9y9/jarvc1
 2Dwqt5fOAGDEuyJyezdz03JDlucZktnL20N8Oh5jsN10y/rXjY
 qBgl/xIICtv2FhgBGIW5RYgvWTWTi0hjMy1frkFoDraQ5oSapk
 0hFc9tnTtRkEa7/FUrdn2EDd+q7vrw0mk3z/3QAZgeS9X7zOiC
 YT9Zrs3X/m+71q2Z8Ul+M2VClYjepfCvFtDo9XF2qUy9HiP3sy
 Cb/lnDix2jixUwhnWNLqFnOtbDnI5pxS3m6gPCKDeeQSVMcLFk
 gCXwlbMqto13g6yGpBB1tcosjesZez/+tn9sxLXOG
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 June 2014, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Provide an implementation for dma_{alloc,free,mmap}_writecombine() when
> the architecture supports DMA attributes.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---

Acked-by: Arnd Bergmann <arnd@arndb.de>

I'd suggest this gets merged through Russell's tree. Please add to the
patch tracker with my Ack.

	Arnd
