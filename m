Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbaGATL0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 15:11:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaGATLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 15:11:24 -0400
From: Andy Grover <agrover@redhat.com>
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, hch@lst.de, nab@linux-iscsi.org,
        shli@kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 0/2] target: userspace pass-through backend
Date: Tue,  1 Jul 2014 12:11:13 -0700
Message-Id: <1404241875-29164-1-git-send-email-agrover@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua Li wrote an initial implementation of this, late last year[1].
Starting from that, I started working on some alternate implementation
choices, and ended up with something rather different.

Please take a look and let me know what you think. Patch 1 is a
design and overview doc, and patch 2 is the actual code, along with
implementation rationale.

Thanks -- Andy

[1] http://thread.gmane.org/gmane.linux.scsi.target.devel/5044

Andy Grover (2):
  target: Add documentation on the target userspace pass-through driver
  target: Add a user-passthrough backstore

 Documentation/target/tcmu-design.txt   |  210 +++++++
 drivers/target/Kconfig                 |    5 +
 drivers/target/Makefile                |    1 +
 drivers/target/target_core_transport.c |    4 +
 drivers/target/target_core_user.c      | 1078 ++++++++++++++++++++++++++++++++
 drivers/target/target_core_user.h      |  126 ++++
 6 files changed, 1424 insertions(+)
 create mode 100644 Documentation/target/tcmu-design.txt
 create mode 100644 drivers/target/target_core_user.c
 create mode 100644 drivers/target/target_core_user.h

-- 
1.9.3

