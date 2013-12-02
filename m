Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab3LBXUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:20:14 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:12654 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab3LBXUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:20:11 -0500
X-AuditID: cbfee690-b7f126d00000418c-0a-529d15aa17d6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Jon Mason'" <jon.mason@intel.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 21/39] NTB: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:20:09 +0900
Message-id: <002a01ceefb5$0b56ccc0$22046640$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAA6rmQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI91VonODDF6eYrNoXryezeLywkus
	Fsd/nGO3uLxrDpsDi8fiPS+ZPPbPXcPu0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBnvprSy
	Faxnq7hz4ABjA+Mm1i5GDg4JAROJr08tuxg5gUwxiQv31rN1MXJxCAksY5R4N2slC0TCRGLx
	tKssEInpjBLNm2cygiSEBH4BOQfAitgE1CS+fDnMDmKLCJhKbHw/BayGWSBTYuU5iBohAVuJ
	6S82M4Es5hSwk+j7VAsSFhZwkLiyYBkbiM0ioCrRfXw1WDkvUPmiL/1sELagxI/J91ggRmpJ
	rN95nAnClpfYvOYtM8Qv6hKP/upCXGAk8eD/QXaIEhGJfS/eMYKcLyFwil3iYBfEOSwCAhLf
	Jh9igeiVldh0gBniXUmJgytusExglJiFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0otM9IoT
	c4tL89L1kvNzNzFCInLCDsZ7B6wPMSYDrZ/ILCWanA+M6LySeENjMyMLUxNTYyNzSzPShJXE
	edUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYBQ042SZUfz1jsVvuevyfWvzdHveLn7X
	c3Pq2/DDC82DHrAr2d8Q4Li0ak5locSmPP1/D88fSf+c5l8j/XdStHasCdultWfXfxDnMVnx
	TddB+pbJ7kdrbjstiFtwrUXtZ/fLiQwCJtwPDzMu7LAqs3m/xZ2h5OaFbOU/H1alH1x0dY9l
	XLx5Y60SS3FGoqEWc1FxIgDZM6dT3gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd1VonODDPY+YbJoXryezeLywkus
	Fsd/nGO3uLxrDpsDi8fiPS+ZPPbPXcPu0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZ76a0shWsZ6u4c+AAYwPjJtYuRk4OCQETicXTrrJA2GISF+6t
	Z+ti5OIQEpjOKNG8eSYjSEJI4BeQcwCsiE1ATeLLl8PsILaIgKnExvdTwGqYBTIlVp6DqBES
	sJWY/mIzUxcjBwengJ1E36dakLCwgIPElQXL2EBsFgFVie7jq8HKeYHKF33pZ4OwBSV+TL7H
	AjFSS2L9zuNMELa8xOY1b5lBRkoIqEs8+qsLcYGRxIP/B9khSkQk9r14xziBUWgWkkmzkEya
	hWTSLCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/wzqR2MKxssDjEKcDAq8fA+
	2D4nSIg1say4MvcQowQHs5IIbyfP3CAh3pTEyqrUovz4otKc1OJDjMlAj05klhJNzgcmo7yS
	eENjEzMjSyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYOy+PCtWKH/pUe3H
	nJ8m/1u+yHeFZbNVxrXjBm/qr0+532g7z3PhxVpfPbdSEQ/mSqXeWi+GlwaObyOsDq8/dcv7
	lseZTJ23ufb/uAU0dywyymkq5pvgIvn62jaVn8HBJj+FfhbsDXD9Zx+jGyxhslZ2Rk9R9PPg
	Z93NBU3Satpvj2kqrbAyUmIpzkg01GIuKk4EAGBWqdo8AwAA
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
 drivers/ntb/ntb_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 170e8e6..5f6373c 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -91,7 +91,7 @@ static struct dentry *debugfs_dir;
 /* Translate memory window 0,1 to BAR 2,4 */
 #define MW_TO_BAR(mw)	(mw * NTB_MAX_NUM_MW + 2)
 
-static DEFINE_PCI_DEVICE_TABLE(ntb_pci_tbl) = {
+static const struct pci_device_id ntb_pci_tbl[] = {
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_BWD)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_JSF)},
 	{PCI_VDEVICE(INTEL, PCI_DEVICE_ID_INTEL_NTB_B2B_SNB)},
-- 
1.7.10.4


