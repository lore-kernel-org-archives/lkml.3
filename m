Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaKMItN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 03:49:13 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:52414 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662AbaKMItL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 03:49:11 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-fd-546470851439
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: pratikp@codeaurora.org, mathieu.poirier@linaro.org,
        gregkh@linuxfoundation.org, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH 0/3] miscellaneous fixes in coresight
Date: Thu, 13 Nov 2014 14:12:46 +0530
Message-id: <1415868169-13325-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrALMWRmVeSWpSXmKPExsWyRsSkRretICXEYNlUFovmxevZLDY9vsZq
	cXnXHDaLrXsOMFks2vqF3eLbfXMHNo/Lfb1MHneu7WHz2D93DbvH5iX1Hn1bVjF6fN4kF8AW
	xWWTkpqTWZZapG+XwJXx475QQS9LxZPfGxgbGCcxdzFyckgImEgsf7INyhaTuHBvPVsXIxeH
	kMBSRomWycvZYIr+nDzHDpFYxCjR8eo2VNUEJolVmyYzglSxCehKPHk/F2yUiICbxI3GDiYQ
	m1mgVuLEumVgcWEBU4nnx1+DTWURUJVYfvA8mM0r4CFx+eVjoBoOoG0KEnMm2YDMlxD4ziYx
	5+M8Joh6AYlvkw+xQNTISmw6AHW1pMTBFTdYJjAKLmBkWMUomlqQXFCclF5kolecmFtcmpeu
	l5yfu4kRGLCn/z2bsIPx3gHrQ4wCHIxKPLwvWVJChFgTy4orcw8xmgJtmMgsJZqcD4yLvJJ4
	Q2MzIwtTE1NjI3NLMyVx3tdSP4OFBNITS1KzU1MLUovii0pzUosPMTJxcEo1MGbGCpyc/b9k
	M/ODVsZvXNtuPtAo/LRt9orJ1spXROLd76y4JVUvLLiqvZQ14NwHmYnfcspFHC4+XTpp8mfG
	2xe4WQ9t3lvd/3+a1sHO8DmnddiKeBddXcrEeeKsy+bzIcfvKS/yVu022702eZNx27nfFZnH
	pVN+xu/8GCoWdfzmdjnniroKX1slluKMREMt5qLiRADeL0cwUwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgG5DQUqIQe8aGYvmxevZLDY9vsZq
	cXnXHDaLrXsOMFks2vqF3eLbfXMHNo/Lfb1MHneu7WHz2D93DbvH5iX1Hn1bVjF6fN4kF8AW
	1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQN0hZJC
	WWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsIYx48d9oYJeloonvzcwNjBOYu5i
	5OSQEDCR+HPyHDuELSZx4d56ti5GLg4hgUWMEh2vbkM5E5gkVm2azAhSxSagK/Hk/VywbhEB
	N4kbjR1MIDazQK3EiXXLwOLCAqYSz4+/ZgOxWQRUJZYfPA9m8wp4SFx++RiohgNom4LEnEk2
	Exi5FzAyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjodnUjsYVzZYHGIU4GBU4uF9wZIS
	IsSaWFZcmXuIUYKDWUmEt0kHKMSbklhZlVqUH19UmpNafIjRFGj5RGYp0eR8YKzmlcQbGpuY
	mxqbWppYmJhZKonzHmi1DhQSSE8sSc1OTS1ILYLpY+LglGpgzFQ+KbyjOnO/S2wQI6dCbPHu
	H0lXNyn/12t79/CKutC2PIZvRl/jS9Zy6+8yytNP7pxv+OeM6PSHDspPeNxC57YWNkse7rjR
	dz7Iskoy0ts74Iz9nb1Lk5fa7EjacG2hs+mcsKsBc1rM5kY4Lpt5rmheYq6U4qNI8eIPYW8/
	5mYnXfhg+HKtEktxRqKhFnNRcSIAt1ljlp0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series fixes some typo and minor issues in coresight which 
I observed while going through this driver.

Pankaj Dubey (3):
  coresight: fix typo in comment in coresight-priv.h
  coresight: fixed comments in coresight.h
  coresight-replicator: remove .owner field for driver

 drivers/coresight/coresight-priv.h       |    2 +-
 drivers/coresight/coresight-replicator.c |    1 -
 include/linux/coresight.h                |    6 +++---
 3 files changed, 4 insertions(+), 5 deletions(-)

-- 
1.7.9.5

