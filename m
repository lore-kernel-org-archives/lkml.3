Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab3LBX3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:29:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:16386 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766Ab3LBX3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:29:14 -0500
X-AuditID: cbfee691-b7f666d0000048b0-82-529d17c84f84
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Rusty Russell'" <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 33/39] virtio: pci: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:29:12 +0900
Message-id: <003601ceefb6$4ef0e6e0$ecd2b4a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABPFrw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zA90T4nODDM7/tbFoXryezeLywkus
	Fpd3zWGzuDntAovF8rPz2BxYPfbPXcPuMfnGckaPFRtOMHv0bVnF6PF5k1wAaxSXTUpqTmZZ
	apG+XQJXxtcjz9kKzrJWzPv7j6mB8QpLFyMnh4SAicTU7ZeYIGwxiQv31rN1MXJxCAksY5SY
	OvMkI0zR0489UIlFjBKNH1exgySEBH4xSkzsLgGx2QTUJL58OQwWFxEwldj4fgojSAOzwBxG
	iWVtuxkhGmwlpr/YDLSOg4NTwE6i71MtSFhYwENi68TZYFewCKhKzHl3Cew6XqDylid7mCBs
	QYkfk++BxZkFtCTW7zzOBGHLS2xe85YZZKSEgLrEo7+6IKaIgJHEjNdWEBUiEvtevAO7RkLg
	HrvE5J4NjBCrBCS+TT7EAtEqK7HpADPEu5ISB1fcYJnAKDELyeJZSBbPQrJ4FpIVCxhZVjGK
	phYkFxQnpReZ6hUn5haX5qXrJefnbmKExOnEHYz3D1gfYkwGWj+RWUo0OR8Y53kl8YbGZkYW
	piamxkbmlmakCSuJ86Y/SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwFh67uaNGXGGc6wu
	1Pi/ZKp4/TVr+dMZ2Yd5d3LMSDeYfa9zC4PfedNCvVrBoIOXrs6wKxPJNdnKGuZozmfAv4fr
	dEpN1KaJC+weWc/O25xfPe+30d7a63r9Eor2bUJmAhM7xS5nXV2Vuy4v8H6T79SJu9qd13qe
	10jrr2LXUF/K+FjrXFrnYSWW4oxEQy3mouJEAO5drVXpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAd0T4nODDLYtt7RoXryezeLywkus
	Fpd3zWGzuDntAovF8rPz2BxYPfbPXcPuMfnGckaPFRtOMHv0bVnF6PF5k1wAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bXI8/ZCs6yVsz7+4+pgfEKSxcjJ4eEgInE
	0489bBC2mMSFe+uBbC4OIYFFjBKNH1exgySEBH4xSkzsLgGx2QTUJL58OQwWFxEwldj4fgoj
	SAOzwBxGiWVtuxkhGmwlpr/YzNTFyMHBKWAn0fepFiQsLOAhsXXibCYQm0VAVWLOu0tgR/AC
	lbc82cMEYQtK/Jh8DyzOLKAlsX7ncSYIW15i85q3zCAjJQTUJR791QUxRQSMJGa8toKoEJHY
	9+Id4wRGoVlIBs1CMmgWkkGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iRGcBJ5J
	72Bc1WBxiFGAg1GJh/fB9jlBQqyJZcWVuYcYJTiYlUR4O3nmBgnxpiRWVqUW5ccXleakFh9i
	TAb6cyKzlGhyPjBB5ZXEGxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMH
	p1QDI/vbHrO1X46WPzP5ke2uWnyqSPLvAh7dx7V7H3p9PFo0d8pGM/aZP7krxD8vdj/P+3Sv
	0DmRIxsOrj3zKNrUtk2np11MV0Jj4uEbgtpFSfcZik+2J26/HhatfbP3sGRle+V34aVhmmrf
	9108JqMTJum/+/rGfWkJ3qlihbaFZZb92Yk/O26WK7EUZyQaajEXFScCAMkoGwlGAwAA
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
 drivers/virtio/virtio_pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
index a37c699..a4a1f7c 100644
--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -91,7 +91,7 @@ struct virtio_pci_vq_info
 };
 
 /* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
-static DEFINE_PCI_DEVICE_TABLE(virtio_pci_id_table) = {
+static const struct pci_device_id virtio_pci_id_table[] = {
 	{ PCI_DEVICE(0x1af4, PCI_ANY_ID) },
 	{ 0 }
 };
-- 
1.7.10.4


