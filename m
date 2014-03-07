Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358AbaCGXjD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:39:03 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:47868 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752204AbaCGXjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:39:00 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/4] checkpatch: enhance compatible string checking
Date: Sat,  8 Mar 2014 00:38:43 +0100
Message-Id: <1394235527-8999-1-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series proposes a number of fixes and enhancements to the checks
performed on compatible strings:

1) Fix vendor check for strings with dashes
2) Fix spurious vendor warning, when there is no vendor
3) Check for compatible strings in .c and .h files too
4) Match only at the begining of each line in vendor-prefixes.txt

Regards,
Florian

Since v3 [3]:
- Removed the SOB of Joe Perches
- Cc: Andrew Morton

Since v2 [2]:
- Merged changes proposed by Joe Perches
1) check compatible also in .[ch] files
2) match strings at the begining of vendor-prefixes.txt
3) minor cleanups

Since v1 [1]:
- Add check for vendors with '-', as suggested by Joe Perches

[1] http://thread.gmane.org/gmane.linux.drivers.devicetree/63770
[2] http://thread.gmane.org/gmane.linux.kernel/1657871
[3] https://lkml.org/lkml/2014/3/7/247

Florian Vaussard (4):
  checkpatch: check vendor compatible with dashes
  checkpatch: fix spurious vendor compatible warnings
  checkpatch: check compatible strings in .c and .h too
  checkpatch: improve the compatible vendor match

 scripts/checkpatch.pl | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

-- 
1.8.5.3

