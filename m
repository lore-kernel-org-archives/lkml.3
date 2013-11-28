Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab3K1COn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:14:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:47253 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab3K1COl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:14:41 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-24-5296a70fa430
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001301ceebdf$628d39e0$27a7ada0$%han@samsung.com>
In-reply-to: <001301ceebdf$628d39e0$27a7ada0$%han@samsung.com>
Subject: [PATCH 3/4] uio: uio_netx: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 11:14:39 +0900
Message-id: <001501ceebdf$97ce30f0$c76a92d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r32JnCDNFapkhQiG6wImy4nCPggAACEAQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY12B5dOCDH4WWzQvXs9mcXnhJVaL
	y7vmsDkwe+yfu4bdo2/LKkaPz5vkApijuGxSUnMyy1KL9O0SuDK+bNnNXtDDWrF0/hL2BsZZ
	LF2MnBwSAiYSaw4uY4ewxSQu3FvP1sXIxSEksIxRouv2MWaYosanSxghEosYJWZNAukGcX4x
	SjRfWM8EUsUmoCbx5cthsFEiAqYSG99PAerg4GAWcJE4Ok0EJCwkYCvR2tnIBBLmFLCTuLHC
	HiQsLOAq8a35O9hBLAKqErcPzQGzeYHKX02ewwxhC0r8mHwPLM4soCWxfudxJghbXmLzmrfM
	ICMlBNQlHv3VhTjASOLkkbNQJSIS+168AztfQmAfu8SF/nVMELsEJL5NPsQC0SsrsekA1LuS
	EgdX3GCZAPQoks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1CtOzC0uzUvXS87P3cQIib7e
	HYy3D1gfYkwGWj+RWUo0OR8YvXkl8YbGZkYWpiamxkbmlmakCSuJ8yY9TAoSEkhPLEnNTk0t
	SC2KLyrNSS0+xMjEwSnVwPhg6YYFc+r9WmblHIpmLGzYEsoV8z7TrPXJP91rmS/rHqnEXfK6
	77F8Vr+4mfBr5U9z37X/6DU5eS4k093v6bTCNkunr84OGpvfe1oeicpIvrnWVtyg7ZCW+b/l
	Z+d2R8kFxzE/XiJ73F7bvL/oY4LhcXuJvV4cWfEZAUslv0+Z+3h/isEWCSWW4oxEQy3mouJE
	AGqqFD/UAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jAV3+5dOCDK7csLJoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZnzZspu9oIe1Yun8JewNjLNYuhg5OSQETCQany5hhLDFJC7cW8/WxcjFISSwiFFi
	1iSQIhDnF6NE84X1TCBVbAJqEl++HGYHsUUETCU2vp8C1M3BwSzgInF0mghIWEjAVqK1s5EJ
	JMwpYCdxY4U9SFhYwFXiW/N3sL0sAqoStw/NAbN5gcpfTZ7DDGELSvyYfA8sziygJbF+53Em
	CFteYvOat8wgIyUE1CUe/dWFOMBI4uSRs1AlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyr
	GEVTC5ILipPScw31ihNzi0vz0vWS83M3MYKj+5nUDsaVDRaHGAU4GJV4eCV0pgUJsSaWFVfm
	HmKU4GBWEuFVKAYK8aYkVlalFuXHF5XmpBYfYkwGenQis5Rocj4w8eSVxBsam5gZWRqZWRiZ
	mJuTJqwkznug1TpQSCA9sSQ1OzW1ILUIZgsTB6dUA+P6r0z3r1nOjTsjUqrzk60rT+WJH4PR
	M1knoRdVjJ/eMh8KjvgUXVtoGDy7QuzlxycHfCvC/4rl15g+5pm39m/7Wrb+AokNEZMWPnFr
	lTTVOfrENze6IenQ3W9hpW82X0mZ8bdc4h//W+6G3EV9p74uenrq/R7T7V6Pbq3Sfrlb8d+S
	vy85exYrsRRnJBpqMRcVJwIAbsqNAjIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is used to create a struct pci_device_id array.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_netx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_netx.c b/drivers/uio/uio_netx.c
index 4c345db..8e85bfb 100644
--- a/drivers/uio/uio_netx.c
+++ b/drivers/uio/uio_netx.c
@@ -132,7 +132,7 @@ static void netx_pci_remove(struct pci_dev *dev)
 	kfree(info);
 }
 
-static struct pci_device_id netx_pci_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(netx_pci_ids) = {
 	{
 		.vendor =	PCI_VENDOR_ID_HILSCHER,
 		.device =	PCI_DEVICE_ID_HILSCHER_NETX,
-- 
1.7.10.4


