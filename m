Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360Ab3LBXPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:15:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:34070 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab3LBXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:15:05 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-2d-529d1478dfab
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Mauro Carvalho Chehab'" <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 15/39] media: pci: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:15:04 +0900
Message-id: <002401ceefb4$55175fb0$ff461f10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAAudXw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zA90KkblBBkvXilg0L17PZnF54SVW
	i8u75rBZ9GzYympxcZ28A6vH/rlr2D36tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr49HuX4wF
	0/grDj59ytLA2MLbxcjJISFgIvFn6i52CFtM4sK99WxdjFwcQgLLGCX+dV9hhSlafv8wM0Ri
	OqPEoVN3WSGcX4wSy9+sZAapYhNQk/jy5TDYKBEBU4mN76cwghQxC0xmlDixciUbSEJIwFZi
	+ovNTF2MHBycAnYSfZ9qQcLCAu4SV7ong81hEVCV+LvjCiOIzQtUfvP+BCYIW1Dix+R7LCA2
	s4CWxPqdx5kgbHmJzWveMoOMlBBQl3j0VxfiBCOJyR/esUGUiEjse/EO7BwJgUvsEtMWPGaH
	2CUg8W3yIRaIXlmJTQeYIR6WlDi44gbLBEaJWUg2z0KyeRaSzbOQrFjAyLKKUTS1ILmgOCm9
	yEivODG3uDQvXS85P3cTIyQq+3Yw3jxgfYgxGWj9RGYp0eR8YFTnlcQbGpsZWZiamBobmVua
	kSasJM676GFSkJBAemJJanZqakFqUXxRaU5q8SFGJg5OqQbG/r1LLr2rbr1Tk2lzTG/lxE93
	ypJrFC95b29zUfklxHPq2SI5naDugwwPAz9PuHblbfSv2l3yDq/VJr+qmsQXcUQ+2Vci6/vc
	d+9Onbt5LEVipnhGxbW3vw7dWHd8tmu5YLt+l8qi0NsbqoJPickafmh9kPpTisXxan7Sk3e1
	RrPvPehztg6drcRSnJFoqMVcVJwIAIuhL9zgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrFKsWRmVeSWpSXmKPExsVy+t9jQd0KkblBBgvnCFg0L17PZnF54SVW
	i8u75rBZ9GzYympxcZ28A6vH/rlr2D36tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePR7l+MBdP4Kw4+fcrSwNjC28XIySEhYCKx/P5hZghbTOLCvfVs
	XYxcHEIC0xklDp26ywrh/GKUWP5mJVgVm4CaxJcvh9lBbBEBU4mN76cwghQxC0xmlDixciUb
	SEJIwFZi+ovNTF2MHBycAnYSfZ9qQcLCAu4SV7ong81hEVCV+LvjCiOIzQtUfvP+BCYIW1Di
	x+R7LCA2s4CWxPqdx5kgbHmJzWveMoOMlBBQl3j0VxfiBCOJyR/esUGUiEjse/GOcQKj0Cwk
	k2YhmTQLyaRZSFoWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiO+WfSOxhXNVgcYhTg
	YFTi4X2wfU6QEGtiWXFl7iFGCQ5mJRHeTp65QUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqc
	D0xHeSXxhsYmZkaWRmYWRibm5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAaHGnfHrz
	was3D3AEZdtPut0ld/TK22zvx0yKQuJ5zNOvGoqZL/PvPNfX9iXnfY8ly8YlZrKal14eL1is
	FmvFIRWnef1q9f2CRkeu72uPBHW3X962+n/423uWXOuyZ848UfRe2ilVkn3BXQ9vPpPJLa+5
	Z71nClyqe/WPhvrEWbeVD5x8wD/zuhJLcUaioRZzUXEiACpvHmo9AwAA
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
 drivers/media/pci/cx25821/cx25821-alsa.c |    2 +-
 drivers/media/pci/cx25821/cx25821-core.c |    2 +-
 drivers/media/pci/sta2x11/sta2x11_vip.c  |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
index 6e91e84..b1e08c3 100644
--- a/drivers/media/pci/cx25821/cx25821-alsa.c
+++ b/drivers/media/pci/cx25821/cx25821-alsa.c
@@ -618,7 +618,7 @@ static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static DEFINE_PCI_DEVICE_TABLE(cx25821_audio_pci_tbl) = {
+static const struct pci_device_id cx25821_audio_pci_tbl[] = {
 	{0x14f1, 0x0920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
diff --git a/drivers/media/pci/cx25821/cx25821-core.c b/drivers/media/pci/cx25821/cx25821-core.c
index b762c5b..e81173c 100644
--- a/drivers/media/pci/cx25821/cx25821-core.c
+++ b/drivers/media/pci/cx25821/cx25821-core.c
@@ -1361,7 +1361,7 @@ static void cx25821_finidev(struct pci_dev *pci_dev)
 	kfree(dev);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(cx25821_pci_tbl) = {
+static const struct pci_device_id cx25821_pci_tbl[] = {
 	{
 		/* CX25821 Athena */
 		.vendor = 0x14f1,
diff --git a/drivers/media/pci/sta2x11/sta2x11_vip.c b/drivers/media/pci/sta2x11/sta2x11_vip.c
index 77edc11..e5cfb6c 100644
--- a/drivers/media/pci/sta2x11/sta2x11_vip.c
+++ b/drivers/media/pci/sta2x11/sta2x11_vip.c
@@ -1303,7 +1303,7 @@ static int sta2x11_vip_resume(struct pci_dev *pdev)
 
 #endif
 
-static DEFINE_PCI_DEVICE_TABLE(sta2x11_vip_pci_tbl) = {
+static const struct pci_device_id sta2x11_vip_pci_tbl[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_STMICRO, PCI_DEVICE_ID_STMICRO_VIP)},
 	{0,}
 };
-- 
1.7.10.4


