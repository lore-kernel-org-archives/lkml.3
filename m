Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754494Ab3LBXdC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:33:02 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:17139 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3LBXc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:32:59 -0500
X-AuditID: cbfee68f-b7f336d00000481b-2b-529d18aaf1fe
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Andy Whitcroft'" <apw@canonical.com>,
        "'Joe Perches'" <joe@perches.com>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
In-reply-to: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
Subject: [PATCH 39/39] checkpatch: remove check for DEFINE_PCI_DEVICE_TABLE
 macro
Date: Tue, 03 Dec 2013 08:32:57 +0900
Message-id: <003c01ceefb6$d522b130$7f681390$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7vsUc6neA2wWIVTNSB4ceFa5FjuwABXaHQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zQ91VEnODDDaeF7P4sFbDonnxejaL
	ywsvsVrMvv+YxeLyrjlsDqwesxp62Tz2z13D7vFl1TVmj74tqxg9Pm+SC2CN4rJJSc3JLEst
	0rdL4Mp40vSfveAuW8X/lVtZGxg3sXYxcnJICJhITNu8jg3CFpO4cG89kM3FISSwjFFi4bYW
	Jpii2zvvsUAkpjNKPHnwghHC+cUosb7tJVgVm4CaxJcvh9lBbBEBU4mN76eAFTEL9DJKNG84
	zgySEBKwlZj+YjNQAwcHp4CdRN+nWpCwsECwxJ6uX+wgYRYBVYmNt3RBwrxA1Y/PPGOBsAUl
	fky+B2YzC2hJrN95nAnClpfYvOYtM0irhIC6xKO/uhAXGEks+NjJDFEiIrHvxTuwayQE7rFL
	fNwEcj8n0CoBiW+TD7FA9MpKbDrADPGvpMTBFTdYJjBKzEKyeRaSzbOQbJ6FZMUCRpZVjKKp
	BckFxUnpRcZ6xYm5xaV56XrJ+bmbGCFx2r+D8e4B60OMyUDrJzJLiSbnA+M8ryTe0NjMyMLU
	xNTYyNzSjDRhJXHe+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUw+n/4cntuWM2pXp6P
	mgKsBv6Lu/hLvyz6lJkhW3VzqeVk9fLaUt7qvUbTVluYfNrZwZDvuHi+nazAA7moDc8dZHdt
	SH9zR2nREX89/VS2JJW1TY4G7ee+5Tn/WnNge33bLcVIxQeZlYZnXgZNKftYsDlihXLj1Kna
	75vuKJqzLZfSizP5/viZEktxRqKhFnNRcSIAY85gD+kCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jQd1VEnODDF68FbL4sFbDonnxejaL
	ywsvsVrMvv+YxeLyrjlsDqwesxp62Tz2z13D7vFl1TVmj74tqxg9Pm+SC2CNamC0yUhNTEkt
	UkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAFarqRQlphTChQKSCwu
	VtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPMeNL0n73gLlvF/5VbWRsYN7F2MXJySAiYSNze
	eY8FwhaTuHBvPVsXIxeHkMB0RoknD14wQji/GCXWt71kAqliE1CT+PLlMDuILSJgKrHx/RSw
	ImaBXkaJ5g3HmUESQgK2EtNfbAZq4ODgFLCT6PtUCxIWFgiW2NP1ix0kzCKgKrHxli5ImBeo
	+vGZZywQtqDEj8kQBzELaEms33mcCcKWl9i85i0zSKuEgLrEo7+6EBcYSSz42MkMUSIise/F
	O8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOAk8k9rB
	uLLB4hCjAAejEg/vg+1zgoRYE8uKK3MPMUpwMCuJ8HbyzA0S4k1JrKxKLcqPLyrNSS0+xJgM
	9OdEZinR5HxggsoriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6p
	Bkb7rXnSX1sltplsaDmVsG4p6+e1S2bF7nkmHDbz7dLvMiYVRyeurLWJ57GwY2iac+LKpJsG
	p2NW6KiaK52M3fPzovGNtJ9zpL8u+2Mal7zO0mjZ2WV+mfulyn59ZPi3+W/8xv0dt/uMvA4F
	pve+LD0y+XFe49I3L46WFKq8lznB8Y953x927UemSizFGYmGWsxFxYkA6vWakEYDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove check for DEFINE_PCI_DEVICE_TABLE macro, because
DEFINE_PCI_DEVICE_TABLE macro is not used anymore.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 scripts/checkpatch.pl |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c98100..4173f72 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2634,12 +2634,6 @@ sub process {
 				$herecurr);
                }
 
-# check for declarations of struct pci_device_id
-		if ($line =~ /\bstruct\s+pci_device_id\s+\w+\s*\[\s*\]\s*\=\s*\{/) {
-			WARN("DEFINE_PCI_DEVICE_TABLE",
-			     "Use DEFINE_PCI_DEVICE_TABLE for struct pci_device_id\n" . $herecurr);
-		}
-
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
-- 
1.7.10.4


