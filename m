Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424Ab3EaIyu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 04:54:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:25906 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3EaIyj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 04:54:39 -0400
X-AuditID: cbfee68e-b7f276d000002279-2f-51a8654e1ebd
From: Seung-Woo Kim <sw0312.kim@samsung.com>
To: dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org, sumit.semwal@linaro.org,
        airlied@linux.ie
Cc: linux-kernel@vger.kernel.org, daniel.vetter@ffwll.ch, inki.dae@samsung.com,
        sw0312.kim@samsung.com, kyungmin.park@samsung.com
Subject: [RFC][PATCH 0/2] dma-buf: add importer private data for reimporting
Date: Fri, 31 May 2013 17:54:45 +0900
Message-id: <1369990487-23510-1-git-send-email-sw0312.kim@samsung.com>
X-Mailer: git-send-email 1.7.4.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsWyRsSkQNcvdUWgwcM90ha9504yWSx8eJfZ
	4srX92wWk+5PYLE42/SG3eLLlYdMFpd3zWGz6NmwldXi1N3P7BYzJr9kc+Dy2PttAYvHnWt7
	2Dy2f3vA6nG/+ziTx+1/j5k9+rasYvT4vEkugD2KyyYlNSezLLVI3y6BK2PH1YVsBXNYKw7P
	P8/awPiQuYuRg0NCwETiwzz+LkZOIFNM4sK99WxdjFwcQgJLGSUmrJ3HDJEwkVhx/zI7RGI6
	o8TSg2ehqpqZJG6de8YKUsUmoCOxf8lvMFtEoJdRYs09JpAiZoFmRolHy/4wgSSEBXwkft+Z
	ClbEIqAqsaVpJVicV8BN4va3c1DrFCQW3HsLtkFCYBW7xIvVN5kgGgQkvk0+xAJxt6zEpgNQ
	9ZISB1fcYJnAKLiAkWEVo2hqQXJBcVJ6kZFecWJucWleul5yfu4mRmCon/73rG8H480D1ocY
	k4HGTWSWEk3OB8ZKXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWpRfFFpTmp
	xYcYmTg4pRoY63Nr/gX1njD7WyJ6TJt1e/jz2gudbkbSRQW/XkStl3//ZvUbhn/MZ6YKrDv5
	i/Nt/O+ngR9e/p69/NMiZ1MhqwQFzkqD/MLqouyNS9IOFM5tVF5TIy0gvGe3whaNha6/fHIm
	PUpPXzDj/5GcpR9TotcJzHm+MfDas/hJvz5c+TLTqLc0JmazuxJLcUaioRZzUXEiAOW6LPeL	AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQV2/1BWBBjcnClv0njvJZLHw4V1m
	iytf37NZTLo/gcXibNMbdosvVx4yWVzeNYfNomfDVlaLU3c/s1vMmPySzYHLY++3BSwed67t
	YfPY/u0Bq8f97uNMHrf/PWb26NuyitHj8ya5APaoBkabjNTElNQihdS85PyUzLx0WyXv4Hjn
	eFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKADlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGENYwZO64uZCuYw1pxeP551gbGh8xdjJwcEgImEivuX2aHsMUkLtxbz9bFyMUh
	JDCdUWLpwbNQTjOTxK1zz1hBqtgEdCT2L/kNZosI9DJKrLnHBFLELNDMKPFo2R8mkISwgI/E
	7ztTwYpYBFQltjStBIvzCrhJ3P52Dmq1gsSCe2/ZJjByL2BkWMUomlqQXFCclJ5rpFecmFtc
	mpeul5yfu4kRHEvPpHcwrmqwOMQowMGoxMN7MGV5oBBrYllxZe4hRgkOZiURXt3gFYFCvCmJ
	lVWpRfnxRaU5qcWHGJOBtk9klhJNzgfGeV5JvKGxiZmRpZG5oYWRsTlpwkrivAdbrQOFBNIT
	S1KzU1MLUotgtjBxcEo1MG55K97k/z7jR82HuRXchzjWv38gOL14/7kFd02Pvk09O+9hNHOg
	3qkTcxdZdClduKv5sPpQiXFmWXCLgsveKwHH+MJq/fosmV+Zvjrfln/28iHmOMYb6qsL9V4I
	7TTbvd141oHMWIF138Nrv3svZwvtrHd9t9/x04mXOdVTDjNzfk3wzDnD4KvEUpyRaKjFXFSc
	CAB6k9sj6QIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

importer private data in dma-buf attachment can be used by importer to
reimport same dma-buf.

Seung-Woo Kim (2):
  dma-buf: add importer private data to attachment
  drm/prime: find gem object from the reimported dma-buf

 drivers/base/dma-buf.c                     |   31 ++++++++++++++++++++++++++++
 drivers/gpu/drm/drm_prime.c                |   19 ++++++++++++----
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c |    1 +
 drivers/gpu/drm/i915/i915_gem_dmabuf.c     |    1 +
 drivers/gpu/drm/udl/udl_gem.c              |    1 +
 include/linux/dma-buf.h                    |    4 +++
 6 files changed, 52 insertions(+), 5 deletions(-)

-- 
1.7.4.1

