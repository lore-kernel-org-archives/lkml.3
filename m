Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab3K1CPV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 21:15:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:25433 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631Ab3K1CPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 21:15:18 -0500
X-AuditID: cbfee690-b7f126d00000418c-27-5296a7302c3d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>
References: <001301ceebdf$628d39e0$27a7ada0$%han@samsung.com>
In-reply-to: <001301ceebdf$628d39e0$27a7ada0$%han@samsung.com>
Subject: [PATCH 4/4] uio: uio_sercos3: use DEFINE_PCI_DEVICE_TABLE macro
Date: Thu, 28 Nov 2013 11:15:11 +0900
Message-id: <001601ceebdf$ab0e0460$012a0d20$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7r32JnCDNFapkhQiG6wImy4nCPggAADZuw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrEIsWRmVeSWpSXmKPExsVy+t8zfV2D5dOCDK7OEbBoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBl3Hy4mLlgGWvFpsVt7A2M
	K1i6GDk5JARMJNZf3cEMYYtJXLi3nq2LkYtDSGAZo8Tyhq/MMEV3nuyBSkxnlHjTeBzK+cUo
	0f1wDRtIFZuAmsSXL4fZQWwRAVOJje+nMHYxcnAwC7hIHJ0mAhIWErCVaO1sZAIJcwrYSdxY
	YQ8SFhbwkGj9tg9sCouAqsS2RVeZQGxeoPKZe4+xQNiCEj8m3wOzmQW0JNbvPM4EYctLbF7z
	lhlkpISAusSjv7oQBxhJrLyzBqpERGLfi3eMIBdLCOxil3jTs5IRYpeAxLfJh1ggemUlNh2A
	eldS4uCKGywTGCVmIdk8C8nmWUg2z0KyYgEjyypG0dSC5ILipPQiE73ixNzi0rx0veT83E2M
	kPibsIPx3gHrQ4zJQOsnMkuJJucD4zevJN7Q2MzIwtTE1NjI3NKMNGElcV61R0lBQgLpiSWp
	2ampBalF8UWlOanFhxiZODilGhhLylW3HytlvmMpJN7PsS3oipfAAU8/PwuB2Ob3xcrnrJKC
	9rA+KQo/wZC+7+MeBRelHl1lRe9vm0/N3nNjSUpKTybHwqIjfxoVT3X3NJgtnv0/se/GyjOX
	85J+mbVNZN1xnvNy8W6jjeW295aeOfL7zQXvZQnb45ial1y7+Xqnw6NHuTmzrA8psRRnJBpq
	MRcVJwIAu9qO0dUCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV2D5dOCDOac47FoXryezeLywkus
	Fpd3zWFzYPbYP3cNu0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY
	6hpaWpgrKeQl5qbaKrn4BOi6ZeYAbVJSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdj
	ZIAGEtYxZtx8uJi5YBlrxabFbewNjCtYuhg5OSQETCTuPNnDBmGLSVy4tx7I5uIQEpjOKPGm
	8TiU84tRovvhGrAqNgE1iS9fDrOD2CICphIb309h7GLk4GAWcJE4Ok0EJCwkYCvR2tnIBBLm
	FLCTuLHCHiQsLOAh0fptH9gUFgFViW2LrjKB2LxA5TP3HmOBsAUlfky+B2YzC2hJrN95nAnC
	lpfYvOYtM8hICQF1iUd/dSEOMJJYeWcNVImIxL4X7xgnMArNQjJpFpJJs5BMmoWkZQEjyypG
	0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Oh+Jr2DcVWDxSFGAQ5GJR5eCZ1pQUKsiWXFlbmH
	GCU4mJVEeBWKgUK8KYmVValF+fFFpTmpxYcYk4EencgsJZqcD0w8eSXxhsYmZkaWRmYWRibm
	5qQJK4nzHmy1DhQSSE8sSc1OTS1ILYLZwsTBKdXAuHXmdPXAxWefnWeKefpws2oBw3amNLWz
	GldPfYg5tPi/Uc9V7++nGIXEbgvUqS4+FyFqyzS3v29hdshT9+bjsrVMh86bxJaeitQUvHL9
	3ru7RlN4udj2cvVXdTc6JNWwmUbdv3sjpW/5uexChiePNadrhYgsD/9x9uJO496EE8bh6fYF
	LXcmKbEUZyQaajEXFScCAE3rkXQyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This macro is used to create a struct pci_device_id array.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_sercos3.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 9cfdfca..f233b03 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -196,7 +196,7 @@ static void sercos3_pci_remove(struct pci_dev *dev)
 	kfree(info);
 }
 
-static struct pci_device_id sercos3_pci_ids[] = {
+static DEFINE_PCI_DEVICE_TABLE(sercos3_pci_ids) = {
 	{
 		.vendor =       PCI_VENDOR_ID_PLX,
 		.device =       PCI_DEVICE_ID_PLX_9030,
-- 
1.7.10.4


