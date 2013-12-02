Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3LBX1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:27:16 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:30909 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab3LBX1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:27:15 -0500
X-AuditID: cbfee68f-b7f336d00000481b-bd-529d175275ee
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Hans J. Koch'" <hjk@hansjkoch.de>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 30/39] uio: uio_mf624: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 08:27:13 +0900
Message-id: <003301ceefb6$08084890$1818d9b0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABKwyA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI90g8blBBtd/MVo0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxttHF5gK
	lrJWzN0+k7GBcTNLFyMnh4SAicT9QwehbDGJC/fWs3UxcnEICSxjlFjeNpkVpmjd8leMILaQ
	wHRGidXHaiHsX4wSR2axgdhsAmoSX74cZgexRQRMJTa+nwJWzyyQLbFxx2moXluJ6S82M3Ux
	cnBwCthJ9H0CGyMs4C1xfccrJhCbRUBV4sD5e2BreYHK921ZwQRhC0r8mHyPBWKklsT6nceZ
	IGx5ic1r3jKDjJQQUJd49FcX4gIjiUM3ZkCVi0jse/GOEeQtCYFj7BIP1/1nhdglIPFt8iEW
	iF5ZiU0HmCG+lZQ4uOIGywRGiVlINs9CsnkWks2zkKxYwMiyilE0tSC5oDgpvchYrzgxt7g0
	L10vOT93EyMkHvt3MN49YH2IMRlo/URmKdHkfGA855XEGxqbGVmYmpgaG5lbmpEmrCTOe/9h
	UpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxtVH8z9dONz9Kiptw5TTq2vPsEgm1t6u3NlW
	cKnbVOVQXtZGj9Jz6d1zZLwree98jbBsa9fdLuzrsqxus2nn86K1tfzn9vr1bbv5vFw03y6n
	KOmE5ynHtDCdUM1W44vXp+0s6rr6q/Ikx9Hj3bMnnMxojGPbJ/6lsfF+lUzzpsYl0pPNN268
	oMRSnJFoqMVcVJwIAFeBClTdAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd1A8blBBu9OWls0L17PZnH07HR2
	i8sLL7FaXN41h82BxWP+Qy+P/XPXsHv0bVnF6PF5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bbRxeYCpayVszdPpOxgXEzSxcjJ4eEgInEuuWvGCFsMYkL99az
	gdhCAtMZJVYfq4WwfzFKHJkFFmcTUJP48uUwO4gtImAqsfH9FLBeZoFsiY07TjNC1NtKTH+x
	mamLkYODU8BOou8T2BhhAW+J6zteMYHYLAKqEgfO32MFsXmByvdtWcEEYQtK/Jh8jwVipJbE
	+p3HmSBseYnNa94yg4yUEFCXePRXF+ICI4lDN2ZAlYtI7HvxjnECo9AsJJNmIZk0C8mkWUha
	FjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIjvZn0jsYVzVYHGIU4GBU4uF9sH1OkBBr
	YllxZe4hRgkOZiUR3k6euUFCvCmJlVWpRfnxRaU5qcWHGJOBHp3ILCWanA9MRHkl8YbGJmZG
	lkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwOiS//5dhq1efqSGtBNvQhrr
	MumjAZvsHr+bP/91eVHG0jN/s/vnKi7+aqA6/6E6yyHmfUffmWhb/v/27t+UiU8m6s2QCXRr
	N/VluPKsacaMle+LF9/IaTx/1+7qVvZrU1OmHha867rT4nLGxDnbl3r9ffH0Q3CzH0/tDU1z
	4TcPBUut5csY9P2UWIozEg21mIuKEwFyO5/IOgMAAA==
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
 drivers/uio/uio_mf624.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_mf624.c b/drivers/uio/uio_mf624.c
index f764adb..d1f95a1 100644
--- a/drivers/uio/uio_mf624.c
+++ b/drivers/uio/uio_mf624.c
@@ -228,7 +228,7 @@ static void mf624_pci_remove(struct pci_dev *dev)
 	kfree(info);
 }
 
-static DEFINE_PCI_DEVICE_TABLE(mf624_pci_id) = {
+static const struct pci_device_id mf624_pci_id[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_HUMUSOFT, PCI_DEVICE_ID_MF624) },
 	{ 0, }
 };
-- 
1.7.10.4


