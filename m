Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab3IMCYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:24:00 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37403 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045Ab3IMCX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:23:59 -0400
X-AuditID: cbfee68e-b7f756d000004512-34-5232773d7604
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
 <001701ceaf83$8921e6c0$9b65b440$%han@samsung.com>
In-reply-to: <001701ceaf83$8921e6c0$9b65b440$%han@samsung.com>
Subject: [PATCH V2] mfd: timberdale: remove unnecessary pci_set_drvdata()
Date: Fri, 13 Sep 2013 11:23:57 +0900
Message-id: <000401ceb028$4cb42d60$e61c8820$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgx4pjQNLnVsKTseFP8zkmoiH8wAADrqwACktm2A=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zA13bcqMgg0Vv5CwuL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJVxbcdExoJd
	3BXTrk9hb2DcxdnFyMkhIWAicanjFTuELSZx4d56ti5GLg4hgWWMEs/2/WOBKXo4aScTRGIR
	o8TB1h2sEM4vRonDM/rAqtgE1CS+fDkMNkoEyL65ZxYTiM0skCfxYfNmRhBbSKBQ4v/Lrcwg
	NqeAncTWpv9gtrCAp8SJ1X+AbA4OFgFVie7LViBhXgFbid3757FA2IISPybfY4EYqSWxfudx
	qPHyEpvXvAVrlRBQl3j0VxfiAiuJKUemQ5WLSOx78Y4R5GQJgWPsEr1tTWAJFgEBiW+TD7FA
	9MpKbDrADPGvpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKpBckFxUnpRUZ6xYm5xaV5
	6XrJ+bmbGCER2beD8eYB60OMyUDrJzJLiSbnAyM6ryTe0NjMyMLUxNTYyNzSjDRhJXFetRbr
	QCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MHrK715f/ydV4NEmq5GB///GuiLWGytZcdROv
	5vwUPGeW8d/7StKp0/euSXyKdJmf9bZ1e/9WTnFm+R0O7gLfuVILPz52nffu88meNs/Z+Q98
	6/wc+zrS3y369n3epMx+BZndPyx9bnT/5Qgq/8qrr3qjT/KfuhjP/2vRRpozb/MzXb345NI3
	JZbijERDLeai4kQACaoupN4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBKsWRmVeSWpSXmKPExsVy+t9jAV3bcqMgg9WfpCwuL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8AS1cBok5GamJJapJCal5yfkpmXbqvk
	HRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0UUmhLDGnFCgUkFhcrKRvh2lCaIibrgVM
	Y4Sub0gQXI+RARpIWMeYcW3HRMaCXdwV065PYW9g3MXZxcjJISFgIvFw0k4mCFtM4sK99Wxd
	jFwcQgKLGCUOtu5ghXB+MUocntHHAlLFJqAm8eXLYXYQWwTIvrlnFlg3s0CexIfNmxlBbCGB
	Qon/L7cyg9icAnYSW5v+g9nCAp4SJ1b/AbI5OFgEVCW6L1uBhHkFbCV275/HAmELSvyYfI8F
	YqSWxPqdx6HGy0tsXvMWrFVCQF3i0V9diAusJKYcmQ5VLiKx78U7xgmMQrOQTJqFZNIsJJNm
	IWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM43p9J72Bc1WBxiFGAg1GJh7cjxihI
	iDWxrLgy9xCjBAezkgivzH/DICHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OB6aivJJ4Q2MT
	MyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg5Lz42PYl2yPPltk2b/Pt
	urxVuAQVle1fOb3Z+tQ54Khd3+/ZyU6Oj0SWz5yZ9jP/7cVJjsG3T1emKX9pfP+c2e6zhNfn
	3WXOPudq619d2RFce7Op60GT5OW424G/z9/s/MM79bSco119zf6ztYtfts20nuN9t6bvXoph
	a51UQbopl48Ea2KYEktxRqKhFnNRcSIAM4WpzDsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL. It also removes unnecessary label such
as 'err_request'.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
Changes since v1:
- Removed unnecessary label such as 'err_request'.

 drivers/mfd/timberdale.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mfd/timberdale.c b/drivers/mfd/timberdale.c
index a6755ec..dbb34f9 100644
--- a/drivers/mfd/timberdale.c
+++ b/drivers/mfd/timberdale.c
@@ -678,7 +678,7 @@ static int timb_probe(struct pci_dev *dev,
 	priv->ctl_mapbase = mapbase + CHIPCTLOFFSET;
 	if (!request_mem_region(priv->ctl_mapbase, CHIPCTLSIZE, "timb-ctl")) {
 		dev_err(&dev->dev, "Failed to request ctl mem\n");
-		goto err_request;
+		goto err_start;
 	}
 
 	priv->ctl_membase = ioremap(priv->ctl_mapbase, CHIPCTLSIZE);
@@ -828,13 +828,10 @@ err_config:
 	iounmap(priv->ctl_membase);
 err_ioremap:
 	release_mem_region(priv->ctl_mapbase, CHIPCTLSIZE);
-err_request:
-	pci_set_drvdata(dev, NULL);
 err_start:
 	pci_disable_device(dev);
 err_enable:
 	kfree(priv);
-	pci_set_drvdata(dev, NULL);
 	return -ENODEV;
 }
 
@@ -851,7 +848,6 @@ static void timb_remove(struct pci_dev *dev)
 
 	pci_disable_msix(dev);
 	pci_disable_device(dev);
-	pci_set_drvdata(dev, NULL);
 	kfree(priv);
 }
 
-- 
1.7.10.4


