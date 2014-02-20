Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaBTJN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:13:28 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:64357 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754799AbaBTJNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:13:15 -0500
Message-ID: <1392887592.5070.42.camel@x220>
Subject: [PATCH 0/2] advansys: remove warning and mark Orphan
From: Paul Bolle <pebolle@tiscali.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Hans de Goede <hdegoede@redhat.com>, Matthew Wilcox <matthew@wil.cx>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 20 Feb 2014 10:13:12 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Feb 2014 09:13:12.0545 (UTC) FILETIME=[FAE6AD10:01CF2E1B]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

0) I've tried to get a trivial patch to the Advansys SCSI driver merged.
It silences a build time warning. See:
- November 2012: https://lkml.org/lkml/2012/11/5/164 ;
- January 2013: https://lkml.org/lkml/2013/1/29/144 ; and
- January 2014: https://lkml.org/lkml/2014/1/8/569 .

That patch seems to be going nowhere. So a kernel build still generates
a warning when this driver is included. After seven years that is
getting pointless.

1) It seems that advansys is unmaintained. The last time its maintainer
touched it - by acking a patch - was in 2008, with commit 25729a7fb88e
("[SCSI] advansys, arcmsr, ipr, nsp32, qla1280, stex: use
pci_ioremap_bar()"). 

2) Fedora kernel people suggested to send this trivial patch to Andrew
Morton directly (see
https://lists.fedoraproject.org/pipermail/kernel/2014-January/004832.html ). They also suggested I'd mark this driver Orphan.

This small series does both.

Paul Bolle (2):
  advansys: change buildtime warning into runtime error
  MAINTAINERS: mark Advansys Orphan

 CREDITS                 | 2 +-
 MAINTAINERS             | 3 +--
 drivers/scsi/advansys.c | 2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

-- 
1.8.5.3

