Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab3ILGht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:37:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:25345 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab3ILGhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:37:47 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-b5-5231613a117c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Hans J. Koch'" <hjk@hansjkoch.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5] uio: uio_aec: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:37:46 +0900
Message-id: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgpOjT534nRYfSDiuPQlOOHeZTQ==
Content-language: ko
x-cr-hashedpuzzle: BO+9 BmFQ FUUM IvqG I+0w Mux7 O6vl Qz+f Sywe Ucvp adWQ d/yE
 fRkx nytj qMJ0
 qotY;4;ZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAaABqAGsAQABoAGEAbgBzAGoAawBvAGMAaAAuAGQAZQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{748AAEB8-C8E4-43AD-A89A-DC18493A3C09};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 12 Sep 2013 06:37:39
 GMT;WwBQAEEAVABDAEgAIAAxAC8ANQBdACAAdQBpAG8AOgAgAHUAaQBvAF8AYQBlAGMAOgAgAHIAZQBtAG8AdgBlACAAdQBuAG4AZQBjAGUAcwBzAGEAcgB5ACAAcABjAGkAXwBzAGUAdABfAGQAcgB2AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {748AAEB8-C8E4-43AD-A89A-DC18493A3C09}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zfV2rRMMgg7tNzBbNi9ezWRw9O53d
	4vLCS6wWl3fNYXNg8Zj/0Mtj/9w17B59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVMWHjJMaC
	NawVE351MDUwbmHpYuTkkBAwkWjZ/I4ZwhaTuHBvPVsXIxeHkMAyRonXR9YwwRStmTOBHSIx
	nVHi5eZzjBDOL0aJR2fugbWzCahJfPlymB3EFhEwldj4fgojiM0skC1x7PtfsHXCAu4Slw63
	gk1lEVCVODNjCyuIzStgKzFz7m0oW1Dix+R7LBC9WhLrdx5ngrDlJTaveQu0iwPoInWJR391
	IVbpScyf8RuqXERi34t3YLdJCExhlfh0+xnUm6YS72+dYYVInGKX+PJjNSPEEQIS3yYfYoEY
	Kiux6QA0KCQlDq64wTKBUWIWkpNmITlpFpKTZiHZvYCRZRWjaGpBckFxUnqRsV5xYm5xaV66
	XnJ+7iZGSFz272C8e8D6EGMy0PqJzFKiyfnAuM4riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQ
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OaNOH4IrFTczw+TEitm3r99r495y+8T96cNV3y
	sFPWyY3+tgVn5ScJPEj6e0X0o0bIq7KUKy4xUbENy87mp7v/idhh/fvBtDJzbcWJt78dqfl3
	Kmrl6haWmx8v5mgFJkz0Ts7/7rztwKSw7Rwmz4TUTrjldc1480t604zE2WZW+icf1GiElrAr
	sRRnJBpqMRcVJwIAmHg7A+ECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQV3LRMMggynrbCyaF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPCxkmMBWtYKyb86mBqYNzC0sXIySEhYCKxZs4EdghbTOLCvfVs
	XYxcHEIC0xklXm4+xwjh/GKUeHTmHjNIFZuAmsSXL4fBOkQETCU2vp/CCGIzC2RLHPv+F2yq
	sIC7xKXDrUwgNouAqsSZGVtYQWxeAVuJmXNvQ9mCEj8m32OB6NWSWL/zOBOELS+xec1boF0c
	QBepSzz6qwuxSk9i/ozfUOUiEvtevAO7TUJgCqvEp9vPoL4xlXh/6wzrBEahWUhWzEKyYhaS
	FbOQzFrAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjqn0nvYFzVYHGIUYCDUYmHt2OW
	QZAQa2JZcWXuIUYJDmYlEd54c8MgId6UxMqq1KL8+KLSnNTiQ4zJwBCYyCwlmpwPTEh5JfGG
	xiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cAY3HSAK1p80uUT3CXB
	e7YIhIrpHDxdFK7/YMpRs4hWHxm1FfscbBl2Pm/bsO2UubZD66mVdz76TEo6srcxb/t+k4R3
	NQzpz341HYz6e6LsfqbJwt//l3x+y1zL9nfrjm/+cVUrNi/tUROqvnmNQ11g28bPWafdU/4v
	u7SIs/EK071ts0/Pu2f6TImlOCPRUIu5qDgRAP15vhA+AwAA
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
 drivers/uio/uio_aec.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/uio/uio_aec.c b/drivers/uio/uio_aec.c
index f3611c2..1549fab 100644
--- a/drivers/uio/uio_aec.c
+++ b/drivers/uio/uio_aec.c
@@ -147,7 +147,6 @@ static void remove(struct pci_dev *pdev)
 	uio_unregister_device(info);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	pci_set_drvdata(pdev, NULL);
 	iounmap(info->priv);
 
 	kfree(info);
-- 
1.7.10.4


