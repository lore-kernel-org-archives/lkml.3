Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaBTLrW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 06:47:22 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:8858 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaBTLrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 06:47:20 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-8f-5305eb45a907
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping fixes for v3.14
Date: Thu, 20 Feb 2014 12:47:05 +0100
Message-id: <1392896825-32299-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLJMWRmVeSWpSXmKPExsVy+t/xq7qur1mDDd4/N7W4vGsOm8XaI3fZ
	LR71vWV3YPY4MeM3i0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlLF60maXgDkfFpSN72RoY
	57F3MXJySAiYSGy9s5ARwhaTuHBvPRuILSSwlFHiyWfVLkYuILubSWL75R9gDWwChhJdb7vA
	ikQEjCQ+v7jCCmIzC/hK3Hm1iqWLkYNDWEBf4v+3apAwi4CqxO0zz5hBbF4BD4kLL86ClUgI
	KEjMmWQzgZF7ASPDKkbR1NLkguKk9FxDveLE3OLSvHS95PzcTYwQL3/Zwbj4mNUhRgEORiUe
	3ojrLMFCrIllxZW5hxglOJiVRHi33WQNFuJNSaysSi3Kjy8qzUktPsTIxMEp1cA4WcZFzU1t
	Z2iXsUj20fIpadNPXdzkoyxWfvvA7LW+Aq8Krl3fecjdr/yNSdOS7wYBG36rX9KpmBJ530Tl
	g5WdXKT/z1fJHxqesz492f35oOsu20MnKw0bphUvqGR8HPqqamburxla72UmzRe5/ula4Zvy
	I75iqvk35H+rOHxjnPh85VaHPO5aJZbijERDLeai4kQAYDxg19ABAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling fixes for dma-mapping subsystem for
ARM and x86 architecture for v3.14.

The following changes since commit b28a960c42fcd9cfc987441fa6d1c1a471f0f9ed:

  Linux 3.14-rc2 (2014-02-09 18:15:47 -0800)

are available in the git repository at:

  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git fixes-for-v3.14

for you to fetch changes up to c091c71ad2218fc50a07b3d1dab85783f3b77efd:

  x86: dma-mapping: fix GFP_ATOMIC macro usage (2014-02-11 09:40:15 +0100)

----------------------------------------------------------------
Marek Szyprowski (2):
      ARM: dma-mapping: fix GFP_ATOMIC macro usage
      x86: dma-mapping: fix GFP_ATOMIC macro usage

 arch/arm/mm/dma-mapping.c |    2 +-
 arch/x86/kernel/pci-dma.c |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)
----------------------------------------------------------------

This pull request contains fixes for incorrect atomic test in
dma-mapping subsystem for ARM and x86 architecture.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
