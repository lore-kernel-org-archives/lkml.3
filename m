Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab3LBW6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 17:58:25 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:11815 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881Ab3LBW6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 17:58:22 -0500
X-AuditID: cbfee691-b7f666d0000048b0-74-529d108de661
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>,
        "'Paul Mackerras'" <paulus@samba.org>,
        "'Ingo Molnar'" <mingo@redhat.com>,
        "'Arnaldo Carvalho de Melo'" <acme@ghostprotocols.net>, x86@kernel.org
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 01/39] perf/x86/intel: remove DEFINE_PCI_DEVICE_TABLE macro
Date: Tue, 03 Dec 2013 07:58:21 +0900
Message-id: <001601ceefb1$ff63e630$fe2bb290$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwAACjkQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t8zQ91egblBBkdalSwutl1kszjw+ACL
	RfPi9WwWlxdeYrW4vGsOm8WlAwuYLNYcWcxu8WPDY1YHDo8rTzk8TvfoeWxa1cnmsX/uGnaP
	9/uusnnM3dXH6NG3ZRWjx+dNcgEcUVw2Kak5mWWpRfp2CVwZCyfsZS04zlnxZkUbUwPjVI4u
	Rg4OCQETiamn1bsYOYFMMYkL99azdTFycQgJLGOU+PztOBNEwkRizpVFTBCJRYwSq9ZsgXJ+
	MUpMufidEaSKTUBN4suXw+wgtoiAqcTG91PA4swCTUwSJ3vcQGwhAVuJ6S82M4Fs5hSwk+j7
	VAsSFhbwltj7bxUriM0ioCrx/NV3NhCbF6h88vVVjBC2oMSPyfdYIEZqSazfCXEcs4C8xOY1
	b5khnlGXePRXF+ICI4l7x5uhSkQk9r14xwhysoRAJ4fEvZM/2CF2CUh8m3yIBaJXVmLTAWaI
	fyUlDq64wTKBUWIWks2zkGyehWTzLCQrFjCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQI
	ie+JOxjvH7A+xJgMtH4is5Rocj4wPeSVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1
	OzW1ILUovqg0J7X4ECMTB6dUA+PZXcL177RP3nZfVrJ+Up1nxE+zN++nNzznkbgYZByT6LJx
	3ued6zb9+HfYhOtu/IoLzyf89tvGFvTPNXz2muOVfrMzI6OmLpKR72Cxna17VcsqvDnq+1e+
	Te08pT/2aB/5f83yUJE8a7Z2ZfqW/s2yKYePfWyzPLiy7fUipy8r0heubHNrdoxSYinOSDTU
	Yi4qTgQAhC2UMgUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAKsWRmVeSWpSXmKPExsVy+t9jAd1egblBBlcfy1pcbLvIZnHg8QEW
	i+bF69ksLi+8xGpxedccNotLBxYwWaw5spjd4seGx6wOHB5XnnJ4nO7R89i0qpPNY//cNewe
	7/ddZfOYu6uP0aNvyypGj8+b5AI4ohoYbTJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0t
	LcyVFPISc1NtlVx8AnTdMnOALlNSKEvMKQUKBSQWFyvp22GaEBripmsB0xih6xsSBNdjZIAG
	EtYxZiycsJe14DhnxZsVbUwNjFM5uhg5OSQETCTmXFnEBGGLSVy4t56ti5GLQ0hgEaPEqjVb
	mCCcX4wSUy5+ZwSpYhNQk/jy5TA7iC0iYCqx8f0UsDizQBOTxMkeNxBbSMBWYvqLzUDNHByc
	AnYSfZ9qQcLCAt4Se/+tYgWxWQRUJZ6/+s4GYvMClU++vooRwhaU+DH5HgvESC2J9TuPM0HY
	8hKb17xlBhkpIaAu8eivLsQFRhL3jjdDlYhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIU
	TS1ILihOSs810itOzC0uzUvXS87P3cQITh/PpHcwrmqwOMQowMGoxMP7YPucICHWxLLiytxD
	jBIczEoivJ08c4OEeFMSK6tSi/Lji0pzUosPMSYDPTqRWUo0OR+Y2vJK4g2NTcyMLI3MLIxM
	zM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgdE/TmXqkntTNTp+3lxhejQvSOnEDMuu
	yE6pI6Ii4svM/garzHu50+XdCi7FK5NETPoXsR2XkniX/fTr5yVnjt6fWhyyojk4g2kOV/2e
	dOuI3Odz7vHvk6ye1iew7NmaHb8mP75cXs+5yy3x53l2M/unjGENeSfXV667/dIibXLku+OG
	mfdN7q9XYinOSDTUYi4qTgQAgXgVe2MDAAA=
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
 arch/x86/kernel/cpu/perf_event_intel_uncore.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 29c2487..faa6175 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -901,7 +901,7 @@ static struct intel_uncore_type *snbep_pci_uncores[] = {
 	NULL,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(snbep_uncore_pci_ids) = {
+static const struct pci_device_id snbep_uncore_pci_ids[] = {
 	{ /* Home Agent */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_UNC_HA),
 		.driver_data = UNCORE_PCI_DEV_DATA(SNBEP_PCI_UNCORE_HA, 0),
@@ -1460,7 +1460,7 @@ static struct intel_uncore_type *ivt_pci_uncores[] = {
 	NULL,
 };
 
-static DEFINE_PCI_DEVICE_TABLE(ivt_uncore_pci_ids) = {
+static const struct pci_device_id ivt_uncore_pci_ids[] = {
 	{ /* Home Agent 0 */
 		PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0xe30),
 		.driver_data = UNCORE_PCI_DEV_DATA(IVT_PCI_UNCORE_HA, 0),
-- 
1.7.10.4


