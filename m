Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3D2VS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 17:18:57 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:15149 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758643Ab3D2VSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 17:18:55 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] partitions: add AIX LVM support
Date: Mon, 29 Apr 2013 23:18:28 +0200
Message-Id: <1367270313-18871-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a revision of the patch serie I sent some days ago, with fixes
based on observations by Karel Zak, and other cleanups.

This enables finding the contiguous partitions in AIX LVM disks.

Patch 1 is actually just a cleanup of msdos.c, but as patch 3 depends
on it I prefer to put it here.

Philippe

[PATCH 1/5] partitions/msdos.c: end-of-line whitespace and semicolon cleanup
[PATCH 2/5] Add aix lvm partitions support files
[PATCH 3/5] partitions/msdos: enumerate also AIX LVM partitions
[PATCH 4/5] partitions/Makefile: compile aix.c if configured.
[PATCH 5/5] partitions/Kconfig: add the AIX_PARTITION entry
