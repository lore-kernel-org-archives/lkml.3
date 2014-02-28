Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbaB1KCI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:02:08 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64678 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaB1KCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:02:03 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-62-53105e98669c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 0/3] regulator: s2mps11: Minor fixes and prepare for S2MPS14
Date: Fri, 28 Feb 2014 11:01:47 +0100
Message-id: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDJMWRmVeSWpSXmKPExsVy+t/xy7oz4gSCDR5s5bLYOGM9q8XUh0/Y
	LF6/MLQ42/SG3eLblQ4mi8u75rBZzDi/j8li7ZG77BYXV3xhslg/4zWLxZzp75gcuD12zrrL
	7rFpVSebR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVcOLqWuWAqR8Xq+3UNjHfZuhg5OSQE
	TCRmvbjABGGLSVy4tx4ozsUhJLCUUeLLoXOsEE4fk8TxSdtYQKrYBIwlNi9fAlYlIrCRUeLg
	/sNgVcwCM5kk/tx8ADZLWMBH4s+tY+wgNouAqkT71J9gcV4Bd4klixuAbA6gfQoScybZTGDk
	XsDIsIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/dxMjJIS+7GBcfMzqEKMAB6MSD+8ET/5gIdbE
	suLK3EOMEhzMSiK8ee4CwUK8KYmVValF+fFFpTmpxYcYmTg4pRoYa/f+V/WYv3uhWPUdP+PK
	kJM/lQpqj4lVcNc9vt0e8shoyz9Bt4cp9nExb6+2deivM40WSX13Pcyyl2f363Uc/zPPnV16
	9WGkRIBPrVu+p5niQnUHj/PP3u9m26W8M8v4X3zyXIOZ3xSs2pWOez5Wlfl0dOsX9oPGk9K5
	HyU/OWE2v+KVjuQXJZbijERDLeai4kQAuHva/f8BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Few days ago I sent patches adding support for S2MPS14 device to the
sec-core/s2mps11 drivers. These patches were rather large as they covered
multiple subsystems so I decided to split everything into smaller, separate
patches.

The original patchset (version 3) can be found here:
http://thread.gmane.org/gmane.linux.kernel.samsung-soc/27194/focus=1649217

This patchset is a small subset of the patchset related to the s2mps11
regulator driver. The third patch here prepares for supporting the S2MPS14
device. I would be glad if it comes in however I understand that without
further patches it is a little premature.

Best regards,
Krzysztof

Krzysztof Kozlowski (3):
  regulator: s2mps11: Don't store registered regulators in state
    container
  regulator: s2mps11: Constify regulator_desc array
  regulator: s2mps11: Copy supported regulators from initconst

 drivers/regulator/s2mps11.c |   85 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 67 insertions(+), 18 deletions(-)

-- 
1.7.9.5

