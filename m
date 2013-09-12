Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab3ILGjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:39:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:37335 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab3ILGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:39:09 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-30-5231618cbf9c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Hans J. Koch'" <hjk@hansjkoch.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
In-reply-to: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
Subject: [PATCH 3/5] uio: uio_mf624: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:39:08 +0900
Message-id: <001201ceaf82$c89dd800$59d98800$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgpOjT534nRYfSDiuPQlOOHeZTQAACewA
Content-language: ko
x-cr-hashedpuzzle: AGvV AO02 C4an EX9M HBXM KV8A RBsT REeL S32H UojZ hLEc jSJJ
 jpJX mage pWwn
 rgaY;4;ZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAaABqAGsAQABoAGEAbgBzAGoAawBvAGMAaAAuAGQAZQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{6C4C8B40-3D2E-4206-9E82-A292EB9046F9};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 12 Sep 2013 06:39:02
 GMT;WwBQAEEAVABDAEgAIAAzAC8ANQBdACAAdQBpAG8AOgAgAHUAaQBvAF8AbQBmADYAMgA0ADoAIAByAGUAbQBvAHYAZQAgAHUAbgBuAGUAYwBlAHMAcwBhAHIAeQAgAHAAYwBpAF8AcwBlAHQAXwBkAHIAdgBkAGEAdABhACgAKQA=
x-cr-puzzleid: {6C4C8B40-3D2E-4206-9E82-A292EB9046F9}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsVy+t8zI92eRMMgg7mTRCyaF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/pBkYIn
	rBVvts5mbGB8w9LFyMkhIWAicXfeF0YIW0ziwr31bF2MHBxCAssYJZ4mw5QcfrMcrFxIYBGj
	RNeMiC5GLiD7F6PElo+T2EESbAJqEl++HAazRQRMJTa+nwI2k1kgW+LY979QzbYS778uYQKx
	OQXsJKasOsEMYgsLeEpMfHcTLM4ioCqx6NB5NhCbF6j+ZuMEVghbUOLH5HssEDO1JNbvPM4E
	YctLbF7zlhnkZgkBdYlHf3UhTjCS2H27nxWiRERi34t3jCA3SwjMYJVY1NDIDvGYqcTZfT1Q
	iUfsEhcOQyxmERCQ+Db5EAvEUFmJTQeYIeolJQ6uuMEygVFqFpKTZiE5aRaSk2Yh2b2AkWUV
	o2hqQXJBcVJ6kalecWJucWleul5yfu4mRkj8TtzBeP+A9SHGZKD1E5mlRJPzgfGfVxJvaGxm
	ZGFqYmpsZG5pRpqwkjiveot1oJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQZGxr6VFUWHooq/
	mppJPjhj5Jy6JsuEV+301KT2Xfv6rh5Jcl84NdBh8iRh49rYc1mf55zZlV0YerNkZt0yXsmv
	p3S7zh3IvfTUx5vHUXv51fh7Jx9bVmUYdr57pMhSm7vluDW7o0exfPPpKMGr3A99Zia9FS89
	Ui58Wnv2C43bi8yWfDWKX2ytxFKckWioxVxUnAgASnFB4/UCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd2eRMMgg/sbBSyaF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMeP6QZGCJ6wVb7bOZmxgfMPSxcjJISFgInH4zXIoW0ziwr31bCC2
	kMAiRomuGRFdjFxA9i9GiS0fJ7GDJNgE1CS+fDkMZosImEpsfD+FEcRmFsiWOPb9LwtEs63E
	+69LmEBsTgE7iSmrTjCD2MICnhIT390Ei7MIqEosOnQebBkvUP3NxgmsELagxI/J91ggZmpJ
	rN95nAnClpfYvOYt0BwOoEPVJR791YU4wUhi9+1+VogSEYl9L94xgtwsITCDVWJRQyM7xGOm
	Emf39TBOYBSZhWTFLCQrZiFZMQvJrAWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxghPE
	M+kdjKsaLA4xCnAwKvHwdswyCBJiTSwrrsw9xCjBwawkwhtvbhgkxJuSWFmVWpQfX1Sak1p8
	iDEZGAITmaVEk/OBySuvJN7Q2MTMyNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuY
	ODilGhintL/+rV9mcSTunHfFc7tZkqJ9xzPvvQgvSP5lkvJmevSW14pbRPzu75jO5Tv5k7a6
	0fQPkj9Tbi9R7jdbftv3hLujYPuytDUFr2KMi+x/8F/l8D2/+3OMd8iUpg0CX5YvFpuq9u/I
	/PKXrF3VLGkW5kwhf1+bZu6Z3PyP6br1Bp/DNw2mv1ysxFKckWioxVxUnAgAzjEyUFQDAAA=
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
 drivers/uio/uio_mf624.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/uio/uio_mf624.c b/drivers/uio/uio_mf624.c
index a1768b2..832afa2 100644
--- a/drivers/uio/uio_mf624.c
+++ b/drivers/uio/uio_mf624.c
@@ -220,7 +220,6 @@ static void mf624_pci_remove(struct pci_dev *dev)
 	uio_unregister_device(info);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-	pci_set_drvdata(dev, NULL);
 
 	iounmap(info->mem[0].internal_addr);
 	iounmap(info->mem[1].internal_addr);
-- 
1.7.10.4


