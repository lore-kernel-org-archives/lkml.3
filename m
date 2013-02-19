Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213Ab3BSC5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 21:57:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:54780 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757791Ab3BSC5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 21:57:42 -0500
X-AuditID: cbfee68d-b7f4f6d000004209-9f-5122ea1b9dce
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>
Cc: "'linux-fbdev'" <linux-fbdev@vger.kernel.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [GIT PULL] exynos-dp updates for v3.9
Date: Tue, 19 Feb 2013 11:57:31 +0900
Message-id: <003a01ce0e4c$dc0f80f0$942e82d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OTNvxAwY0KcJpR26zj4Kosnv2NQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLIsWRmVeSWpSXmKPExsVy+t8zI13pV0qBBvvvy1mc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDL6tkxkLFjEUfFu1wSWBsZ3bF2MHBwSAiYS29rkuxg5
	gUwxiQv31gOFuTiEBJYxShxuvsEIkTCRuLJ6PStEYhGjxIa9U5ggnF+MEocudrGBVLEJqEl8
	+XKYHcQWAep48HEhI0gRs8BbRomPj/aCjRIW0JPYeK6JCcRmEVCV2N7WC2bzCthKLLr1hBHC
	FpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zBBnq0s8+qsLsUtP4tmXbjaIEhGJfS/ege2VEOhn
	l5j8qJ0FYpeAxLfJh1ggemUlNh1ghvhMUuLgihssExjFZiHZPAvJ5llINs9CsmIBI8sqRtHU
	guSC4qT0IkO94sTc4tK8dL3k/NxNjJCo6d3BePuA9SHGZKD1E5mlRJPzgVGXVxJvaGxsYmZi
	amJuaWpuSpqwkjiv3CWZQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2Ms28n5h0v26qrayK+
	/I5BbP/2RY0bdP6uW3b7tYX5SssnF9/b5H4Q6mVq+Hf+622BLevfNn05G7N1uvp0Ho581+OW
	bB/iQ098rmZem62YyfjkQmPzmvrPU5+otV/p8pD7ppARv0lk4sL3qzyfd+9y2nBc6fWv+ztr
	nTuDFcP/bI68W9fk7/RluRJLcUaioRZzUXEiAEwUXfewAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jAV3pV0qBBp9WSFmc6PvAanF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz+rZMZCxYxFHx
	btcElgbGd2xdjJwcEgImEldWr2eFsMUkLtxbDxTn4hASWMQosWHvFCYI5xejxKGLXWAdbAJq
	El++HGYHsUWAuh98XMgIUsQs8JZR4uOjvYwgCWEBPYmN55qYQGwWAVWJ7W29YDavgK3EoltP
	GCFsQYkfk++xgNjMAloS63ceZ4Kw5SU2r3nL3MXIAXSSusSjv7oQu/Qknn3pZoMoEZHY9+Id
	4wRGgVlIJs1CMmkWkkmzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREclc+kdjCu
	bLA4xCjAwajEw+vhohQoxJpYVlyZe4hRgoNZSYS3ox0oxJuSWFmVWpQfX1Sak1p8iDEZ6NGJ
	zFKiyfnAhJFXEm9obGJmZGlkZmFkYm5OmrCSOC/jqScBQgLpiSWp2ampBalFMFuYODilGhiV
	nfr+NCnMY+pR637ep9dy4/ZSea8+w1+zeXM4hIuiousku5m33Mq/47hMf/v7L1U3zItunyuw
	k7izrPyxkAhT4KouE6frdmm5q5f3z/j69PW740+Z4oJ0+lfu4T9/Iok5WefF/PkhCQtSwjhU
	10czpj3at2qCr8OVW4p77vSy3tOr1ml6HKrEUpyRaKjFXFScCACCkCc0DgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Florian, the fbdev maintainer, has been very busy lately, so I send the pull request
for exynos-dp for this merge window.

The following changes since commit 19f949f52599ba7c3f67a5897ac6be14bfcb1200:

 Linux 3.8 (Mon Feb 18 15:58:34 2013 -0800)

are available in the git repository at:
  git://github.com/jingoo/linux.git exynos-dp-next

for you to fetch changes up to bb80934325dab97b479815aed237ebec33ed1c57:

 video: exynos_dp: move disable_irq() to exynos_dp_suspend() (Tue Jan 29 18:26:05 2013 +0900)

----------------------------------------------------------------
exynos-dp updates for the v3.9:

- The missing function calls are fixed.
----------------------------------------------------------------

Ajay Kumar (1):
      video: exynos_dp: move disable_irq() to exynos_dp_suspend()

Jingoo Han (1):
      video: exynos_dp: add missing of_node_put()

drivers/video/exynos/exynos_dp_core.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

--
Best regards,
Jingoo Han

