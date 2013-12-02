Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab3LBXRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:17:44 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12309 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3LBXRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:17:41 -0500
X-AuditID: cbfee691-b7f666d0000048b0-74-529d1514c73d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Chris Ball'" <cjb@laptop.org>, linux-mmc@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 18/39] mmc: dw_mmc-pci: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:17:39 +0900
Message-id: <002701ceefb4$b20755e0$161601a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAA1GLw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zY10R0blBBtf381lsf72RzaJ58Xo2
	i8sLL7FaXN41h83iyP9+RgdWj0NX1jJ67J+7ht2jb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4
	Mn6u2c9c0MtWce2jYAPjbNYuRk4OCQETiWm9xxghbDGJC/fWs3UxcnEICSxjlOh6tIgFpmjt
	od/sEInpjBJ7p1xjgnB+MUpcOdcIVsUmoCbx5cthdhBbRMBUYuP7KYwgRcwCDYwS12ZvZAZJ
	CAnYSkx/sRmom4ODU8BOou9TLUhYWMBH4t29v2BzWARUJS78fQl2Hi9Q+a9pf6FsQYkfk++B
	1TALaEms33mcCcKWl9i85i0zyEgJAXWJR391QUwRASOJxYvcISpEJPa9eAd2jYTANXaJRavv
	skKsEpD4NvkQC0SrrMSmA8wQ/0pKHFxxg2UCo8QsJItnIVk8C8niWUhWLGBkWcUomlqQXFCc
	lF5kqlecmFtcmpeul5yfu4kREp0TdzDeP2B9iDEZaP1EZinR5HxgdOeVxBsamxlZmJqYGhuZ
	W5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+PZwD3mWuyKJ55Nr3Nnfr12
	iuvhPzpvzpi6au85vv5eH1vv2eUT+roXf7hdxKO39v3alWzGcWlhhfbFfLxSb96+6Zr1LLHn
	TkOSeNuGfc/XzHzE6y/Zr+QVs0Rv8dOtrPFTlkrck42wvjV/y/uVGWZ3JoWXxE2sm6GRLWz+
	1a9do+kU5+0e2QYlluKMREMt5qLiRACfq+NV5AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jQV0R0blBBifucllsf72RzaJ58Xo2
	i8sLL7FaXN41h83iyP9+RgdWj0NX1jJ67J+7ht2jb8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS
	81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgBYrKZQl5pQChQISi4uV9O0w
	TQgNcdO1gGmM0PUNCYLrMTJAAwnrGDN+rtnPXNDLVnHto2AD42zWLkZODgkBE4m1h36zQ9hi
	EhfurWfrYuTiEBKYziixd8o1JgjnF6PElXONLCBVbAJqEl++HAbrEBEwldj4fgojSBGzQAOj
	xLXZG5lBEkICthLTX2wG6ubg4BSwk+j7VAsSFhbwkXh37y/YHBYBVYkLf1+CXcELVP5r2l8o
	W1Dix+R7YDXMAloS63ceZ4Kw5SU2r3nLDDJSQkBd4tFfXRBTRMBIYvEid4gKEYl9L94xTmAU
	moVk0Cwkg2YhGTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMGx/0xqB+PKBotD
	jAIcjEo8vA+2zwkSYk0sK67MPcQowcGsJMLbyTM3SIg3JbGyKrUoP76oNCe1+BBjMtCfE5ml
	RJPzgWkpryTe0NjEzMjSyMzCyMTcnDRhJXHeA63WgUIC6YklqdmpqQWpRTBbmDg4pRoYF9R9
	0BXLtl21Ls26f9Hxq6Wba9ftv6ehqvlix7LIu4uvb90futGfZ8XHs1aZjOL5ix4xv3lz8IHs
	gWnXZlyq6Om6ppiYe06KZ5rwnIud33dKKtXNNv/zh29lxHuFwpWbfj8NsruTf4Xj7X/W+dl3
	Y1rMsh9Xhi5a3fZ5UXdxoNNzWS23ulNL0pRYijMSDbWYi4oTAUNswd1BAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
is not preferred.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mmc/host/dw_mmc-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc-pci.c b/drivers/mmc/host/dw_mmc-pci.c
index f70546a..6ada1b3 100644
--- a/drivers/mmc/host/dw_mmc-pci.c
+++ b/drivers/mmc/host/dw_mmc-pci.c
@@ -102,7 +102,7 @@ static int dw_mci_pci_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(dw_mci_pci_pmops, dw_mci_pci_suspend, dw_mci_pci_resume);
 
-static DEFINE_PCI_DEVICE_TABLE(dw_mci_pci_id) = {
+static const struct pci_device_id dw_mci_pci_id[] = {
 	{ PCI_DEVICE(SYNOPSYS_DW_MCI_VENDOR_ID, SYNOPSYS_DW_MCI_DEVICE_ID) },
 	{}
 };
-- 
1.7.10.4


