Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838Ab3FQFQx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 01:16:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15659 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab3FQFQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 01:16:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Sun, 16 Jun 2013 22:16:27 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "yj44.cho@samsung.com" <yj44.cho@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
Date: Mon, 17 Jun 2013 07:16:22 +0200
Subject: Re: [PATCH] ARM: dma-mapping: Get pages if the cpu_addr is out of
 atomic_pool
Thread-Topic: [PATCH] ARM: dma-mapping: Get pages if the cpu_addr is out of
 atomic_pool
Thread-Index: Ac5rGc+fshFlJY/aQcSVSP/s/9/fGg==
Message-ID: <20130617.081622.332935718957738769.hdoyu@nvidia.com>
References: <1371442732-15088-1-git-send-email-yj44.cho@samsung.com>
In-Reply-To: <1371442732-15088-1-git-send-email-yj44.cho@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

YoungJun Cho <yj44.cho@samsung.com> wrote @ Mon, 17 Jun 2013 06:18:52 +0200:

> In __iommu_get_pages(), the cpu_addr is checked wheather in
> atomic_pool range or not. So if the cpu_addr is in atomic_pool
> range, it does not need to check twice.
> 
> Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Looks ok to me, at least.
