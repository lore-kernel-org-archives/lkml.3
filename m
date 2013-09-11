Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3IKMN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 08:13:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:23827 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab3IKMN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 08:13:26 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-48-52305e64a96e
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [GIT PULL] DMA-mapping updates for v3.12 (part 2)
Date: Wed, 11 Sep 2013 14:13:15 +0200
Message-id: <1378901595-29830-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t9jAd2UOIMgg56nehaXd81hs1h75C67
	xaO+t+wOzB4nZvxm8ejbsorR4/MmuQDmKC6blNSczLLUIn27BK6M/48PsRUs5a7on/ieuYFx
	C2cXIyeHhICJxJWOZlYIW0ziwr31bCC2kMAiRon13d4QdjuTxJP3QSA2m4ChRNfbLrAaEQEj
	ic8vroD1Mgv4Stx5tYoFxBYWsJJ4cvYzE4jNIqAq8WnLWrB6XgEPiXt3LzN2MXIA7VKQmDPJ
	ZgIj9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwV5+Jr2DcVWDxSFGAQ5GJR7eG3L6
	QUKsiWXFlbmHGCU4mJVEeB+YGgQJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKa
	nZpakFoEk2Xi4JRqYFxVlyWp85xzq41ixaw3l65FHWiSkXhTNyV9fvhUb7W1h1Z/sakp/s72
	+HFHV6PiPZ2ynOB13tlJu23CU+QKXuQY8Ep//KIptqF4xe7UzfouorN2pixePtWx/8NWszh5
	s5DAOOf7Ajt6P9U9OPb38Wn3dJV6a+s4MdH+Lfq7Z8xfPuPRgTzuhUosxRmJhlrMRcWJAC2c
	7ljuAQAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I would like to ask You for pulling another update of Contiguous Memory
Allocator driver for dma-mapping subsystem for v3.12.


The following changes since commit 26b0332e30c7f93e780aaa054bd84e3437f84354:

  Merge tag 'dmaengine-3.12' of git://git.kernel.org/pub/scm/linux/kernel/git/djbw/dmaengine (2013-09-09 18:07:15 -0700)

are available in the git repository at:


  git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git for-v3.12-fix

for you to fetch changes up to aca0156a9c4ba47ca021b69d1fd7442aff49a7ab:

  drivers: of: fix build break if asm/dma-contiguous.h is missing (2013-09-10 15:43:40 +0200)

----------------------------------------------------------------
Marek Szyprowski (1):
      drivers: of: fix build break if asm/dma-contiguous.h is missing

 drivers/of/of_reserved_mem.c |    2 --
 1 file changed, 2 deletions(-)

----------------------------------------------------------------

This pull request contains a build bugfix for the device tree support
for reserved memory regions. Due to superfluous include the common code
failed to build on ARM64 and MIPS architectures.

I'm really sorry for disturbing you with such stupid patch, but the
patch that caused the build break has lived at linux-next for about two
weeks and noone noticed the issue, what convinced me that everything is
ok.

Thanks!

Best regards
Marek Szyprowski
Samsung R&D Institute Poland
