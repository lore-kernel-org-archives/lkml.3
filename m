Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab3ILGli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:41:38 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60697 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab3ILGle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:41:34 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-78-5231621c2448
From: Jingoo Han <jg1.han@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Peter Tyser'" <ptyser@xes-inc.com>
Subject: [PATCH 1/3] mfd: lpc_ich: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:41:32 +0900
Message-id: <001501ceaf83$1e558220$5b008660$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgx4pjQNLnVsKTseFP8zkmoiH8w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zY12ZJMMgg2VNXBaXF15itbj/9Sij
	xeVdc9gsDj5/y2JxupvVgdXjzrU9bB7zTgZ69G1ZxejxeZOcx6r22awBrFFcNimpOZllqUX6
	dglcGd+33WQumMNesfvCLOYGxk+sXYwcHBICJhLNt5S7GDmBTDGJC/fWs3UxcnEICSxjlNh1
	qJcFImEice3YSSaIxCJGicZZa9khnF+MEq0T+9lAqtgE1CS+fDnMDjJVRMBL4tadIJAws0CW
	xK+tG8EGCQu4S5x6fp4VxGYRUJX4dLyHEcTmFbCVePTlMzuELSjxY/I9FoheLYn1O48zQdjy
	EpvXvGWGOFpd4tFfXYhNehJn11pDVIhI7HvxjhHkMgmBfewS058vh1olIPFt8iEWiFZZiU0H
	mCHekpQ4uOIGywRGsVlIFs9CsngWksWzkKxYwMiyilE0tSC5oDgpvchUrzgxt7g0L10vOT93
	EyMk4ibuYLx/wPoQYzLQ+onMUqLJ+cCIzSuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2x
	JDU7NbUgtSi+qDQntfgQIxMHp1QD42atyoUG3YdZhBQky2Z2lyb65vcxRhxa4byqrMvrqMVF
	OdlXOyVnH79mtnj5gZlVDF1ZKataut1efmVhvVevH6SkszvDbi574MVTPGUVrcs3Zz24suDb
	pW72X0/Xtv5853fK58hVP8deo4PPU96u/Of/0sat7VftHa3t77YyFr4WWiRQ+uPyTiWW4oxE
	Qy3mouJEAJTF/mfOAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jAV2ZJMMgg9WNbBaXF15itbj/9Sij
	xeVdc9gsDj5/y2JxupvVgdXjzrU9bB7zTgZ69G1ZxejxeZOcx6r22awBrFENjDYZqYkpqUUK
	qXnJ+SmZeem2St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QLuVFMoSc0qBQgGJxcVK
	+naYJoSGuOlawDRG6PqGBMH1GBmggYR1jBnft91kLpjDXrH7wizmBsZPrF2MnBwSAiYS146d
	ZIKwxSQu3FvP1sXIxSEksIhRonHWWnYI5xejROvEfjaQKjYBNYkvXw4DJTg4RAS8JG7dCQIJ
	MwtkSfzaupEFxBYWcJc49fw82AIWAVWJT8d7GEFsXgFbiUdfPrND2IISPybfY4Ho1ZJYv/M4
	E4QtL7F5zVtmkPESAuoSj/7qQmzSkzi71hqiQkRi34t3jBMYBWYhGTQLyaBZSAbNQtKygJFl
	FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwRD+T2sG4ssHiEKMAB6MSD2/HLIMgIdbEsuLK
	3EOMEhzMSiK88eaGQUK8KYmVValF+fFFpTmpxYcYk4H+nMgsJZqcD0w2eSXxhsYmZkaWRmYW
	Ribm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAmM5t4rYz3emiddFDPo6gZZcf7NqZ
	ezXBrqgtt919z6bCpIgGsQNPNuyTT396Y3bJqV2vjH5wZd3kfdpsH9xwqK9I0jWtmG3u6Tln
	+xdmFz7w2mt04Hnl07r0HubC8+W7PGo5VTd9ZV1pZXdYoexPIG+QYK77ssmfN4Z9uLU2xTH0
	99RXE1ruKrEUZyQaajEXFScCAG7kZOssAwAA
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
 drivers/mfd/lpc_ich.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index 9483bc8..316af07 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -969,7 +969,6 @@ static int lpc_ich_probe(struct pci_dev *dev,
 	if (!cell_added) {
 		dev_warn(&dev->dev, "No MFD cells added\n");
 		lpc_ich_restore_config_space(dev);
-		pci_set_drvdata(dev, NULL);
 		return -ENODEV;
 	}
 
@@ -980,7 +979,6 @@ static void lpc_ich_remove(struct pci_dev *dev)
 {
 	mfd_remove_devices(&dev->dev);
 	lpc_ich_restore_config_space(dev);
-	pci_set_drvdata(dev, NULL);
 }
 
 static struct pci_driver lpc_ich_driver = {
-- 
1.7.10.4


