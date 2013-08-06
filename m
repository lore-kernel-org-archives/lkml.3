Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab3HFKiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 06:38:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:54917 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3HFKh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 06:37:58 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-ed-5200d2051bcd
From: Jingoo Han <jg1.han@samsung.com>
To: "'Vinod Koul'" <vinod.koul@intel.com>
Cc: "'Dan Williams'" <djbw@fb.com>, Barry Song <baohua.song@csr.com>,
        "'Rongjun Ying'" <Rongjun.Ying@csr.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] dma: sirf: use NULL instead of 0
Date: Tue, 06 Aug 2013 19:37:56 +0900
Message-id: <000301ce9291$039da7a0$0ad8f6e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6SkO5BZNM7OHWLTQuwx/gOfObyzw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zQ13WSwxBBo1NYhYvZ15ltdjc/4DN
	4vKuOWwW+y78YbV42befxYHVY9fOOaweE5vfsXss3vOSyePzJrkAligum5TUnMyy1CJ9uwSu
	jJPHkgtmsVVsvCjQwDiJtYuRk0NCwETi0/fTLBC2mMSFe+vZQGwhgWWMEhdmm3YxcoDV/Hur
	3MXIBRSezigx//MqZgjnF6NE+4RmdpAGNgE1iS9fDrODNIgIqEssvS4DUsMs0Mko8XXBA7Ch
	wgKmErePzwFbzCKgKnFg+Q5mEJtXwFKic+4fFghbUOLH5HtgNrOAlsT6nceZIGx5ic1r3jJD
	HKogsePsa0YQW0RAT2LdxT52iBoRiX0v3jFC1Bxil7i6Mwdil4DEt8mHWCCekZXYdABqjKTE
	wRU3WCYwis1CsnkWks2zkGyehWTDAkaWVYyiqQXJBcVJ6UWGesWJucWleel6yfm5mxghkda7
	g/H2AetDjMlA6ycyS4km5wMjNa8k3tDYzMjC1MTU2Mjc0ow0YSVxXrUW60AhgfTEktTs1NSC
	1KL4otKc1OJDjEwcnFINjDx2kSZrlPn2fGsSyj1eLfVvYo31kfDwQzWC/azCq7wyZLXrkprX
	yOg629dpmDDftIt0dEvP/DlfI+PUROFv/MWXffsi+vUT3fssjewUtij7pIQeZfpzYVeq9eN/
	5dsa5nJaLdu7bDdHRWDCpb3dl+TrZn8z0XW01Im/vv7skrUCn+3sI44qsRRnJBpqMRcVJwIA
	VVUaIcoCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jQV3WSwxBBo/bhSxezrzKarG5/wGb
	xeVdc9gs9l34w2rxsm8/iwOrx66dc1g9Jja/Y/dYvOclk8fnTXIBLFENjDYZqYkpqUUKqXnJ
	+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QIuVFMoSc0qBQgGJxcVK+naY
	JoSGuOlawDRG6PqGBMH1GBmggYR1jBknjyUXzGKr2HhRoIFxEmsXIweHhICJxL+3yl2MnECm
	mMSFe+vZuhi5OIQEpjNKzP+8ihnC+cUo0T6hmR2kik1ATeLLl8PsIM0iAuoSS6/LgNQwC3Qy
	Snxd8IANpEZYwFTi9vE5rCA2i4CqxIHlO5hBbF4BS4nOuX9YIGxBiR+T74HZzAJaEut3HmeC
	sOUlNq95ywxxkYLEjrOvGUFsEQE9iXUX+9ghakQk9r14xziBUWAWklGzkIyahWTULCQtCxhZ
	VjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Iz6R2MqxosDjEKcDAq8fAmXP0fKMSaWFZc
	mXuIUYKDWUmEV2UnQ5AQb0piZVVqUX58UWlOavEhxmSgTycyS4km5wPTTF5JvKGxiZmRpZGZ
	hZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MK5R+MfwVXfdMsl+/jV9e36q/hGu
	XzPRR2nF5MJC+aS9kyYnc2hYCSrt3rrmeuyUtICVeodDVjDbrJ2UN0P5v9YTU+2PKtcZ3Zn9
	GbivBn/VmXNgUm7yBb+LDKYvhZ2/Cp5Iy9PYtbb9RdHtYvZvqUIJ5xPS1x4Q5pwovf649i2D
	af8OFa72SVNiKc5INNRiLipOBAA8vbfCKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sirfsoc_dma_prep_cyclic() returns pointer, thus NULL should be
used instead of 0 in order to fix the following sparse warning:

drivers/dma/sirf-dma.c:598:24: warning: Using plain integer as NULL pointer

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dma/sirf-dma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 716b23e..973ecd0 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -595,7 +595,7 @@ sirfsoc_dma_prep_cyclic(struct dma_chan *chan, dma_addr_t addr,
 	spin_unlock_irqrestore(&schan->lock, iflags);
 
 	if (!sdesc)
-		return 0;
+		return NULL;
 
 	/* Place descriptor in prepared list */
 	spin_lock_irqsave(&schan->lock, iflags);
-- 
1.7.10.4


