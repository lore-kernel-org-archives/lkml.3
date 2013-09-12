Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3ILGiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:38:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60121 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab3ILGit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:38:49 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-e2-52316174830e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Hans J. Koch'" <hjk@hansjkoch.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
In-reply-to: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
Subject: [PATCH 2/5] uio: uio_cif: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:38:44 +0900
Message-id: <001101ceaf82$ba4e3560$2eeaa020$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgpOjT534nRYfSDiuPQlOOHeZTQAABDhg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zI92SRMMggw2ThS2aF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/O8DywF
	x1grdlzibmA8y9LFyMkhIWAisXPeXGYIW0ziwr31bF2MXBxCAssYJdavvsIIU7T09FFWiMR0
	RoneI++ZQBJCAr8YJS40J4LYbAJqEl++HGYHsUUETCU2vp8C1swskC1x7PtfFoh6W4n3X5eA
	9XIK2ElMWXUCaDMHh7CAu8Seh0EgYRYBVYnZf7eygYR5gcrn7uQHCfMKCEr8mHyPBWKilsT6
	nceZIGx5ic1r3oJNkRBQl3j0VxfiACOJw127oUpEJPa9eMcIcr2EwCl2iV3LVrNCrBKQ+Db5
	EAtEr6zEpgPQYJCUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4
	NC9dLzk/dxMjJBon7mC8f8D6EGMy0PqJzFKiyfnAaM4riTc0NjOyMDUxNTYytzQjTVhJnFe9
	xTpQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA6PH4ysK6nzzp5xLXZi/48sXY4dLpfwf56+r
	Lgn4eni71K/eS/sOpNyfseqKVES+9jaeFlmbH2qn/nq11XQcqannZ2zfLPCnm2UWv+Ry8/l3
	Vy2fGHcktkl7gcpX2VVNH3R4Th812fHR9vOeXuZgkwXhwt99n5p/yIrd9q9NRH5Lx+LOKK91
	6kFKLMUZiYZazEXFiQBTUhi63AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t9jQd2SRMMgg98v+C2aF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePzvA8sBcdYK3Zc4m5gPMvSxcjJISFgIrH09FFWCFtM4sK99Wxd
	jFwcQgLTGSV6j7xnAkkICfxilLjQnAhiswmoSXz5cpgdxBYRMJXY+H4KI4jNLJAtcez7XxaI
	eluJ91+XgPVyCthJTFl1grmLkYNDWMBdYs/DIJAwi4CqxOy/W9lAwrxA5XN38oOEeQUEJX5M
	vscCMVFLYv3O40wQtrzE5jVvwaZICKhLPPqrC3GAkcThrt1QJSIS+168Y5zAKDQLyaRZSCbN
	QjJpFpKWBYwsqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCY/2Z1A7GlQ0WhxgFOBiVeHg7
	ZhkECbEmlhVX5h5ilOBgVhLhjTc3DBLiTUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGAayiuJ
	NzQ2MTOyNDKzMDIxNydNWEmc90CrdaCQQHpiSWp2ampBahHMFiYOTqkGRv+3/yweVqVOUNTP
	+t1v6s3ZY9vvusF3dccHWSclk2/Omg9FIy9t3+37f3bKv1cPqhbwif3PUf0RL3JnT6DiLgmf
	sJznlzL3lE35ODHW4Oi78JV7Ow7M5Vi/qKvxRMHeCUwvfV+0/Do2tfzkNqOpqcH/i72FnWz7
	CyeI7E2a5aQeXMajpSEbrcRSnJFoqMVcVJwIAKMyoEE5AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_cif.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/uio/uio_cif.c b/drivers/uio/uio_cif.c
index 22cdf38..30f533c 100644
--- a/drivers/uio/uio_cif.c
+++ b/drivers/uio/uio_cif.c
@@ -106,7 +106,6 @@ static void hilscher_pci_remove(struct pci_dev *dev)
 	uio_unregister_device(info);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-	pci_set_drvdata(dev, NULL);
 	iounmap(info->mem[0].internal_addr);
 
 	kfree (info);
-- 
1.7.10.4


