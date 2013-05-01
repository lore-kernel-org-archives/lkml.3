Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3EAGJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 02:09:46 -0400
Received: from smtp2.macqel.be ([194.78.208.39]:12812 "EHLO smtp2.macqel.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab3EAGJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 02:09:38 -0400
From: Philippe De Muyter <phdm@macqel.be>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Karel Zak <kzak@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 0/5] partitions: Add aix lvm partitions support          
Date: Wed,  1 May 2013 08:09:17 +0200
Message-Id: <1367388562-2213-1-git-send-email-phdm@macqel.be>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the version 3 of my patchset to add a basic aix lvm partitions
parser to linux.
The only modified patch is patch 2.  It fixes a problem in the discovering
of small (1 pp) partitions in presence of discontiguous partitions.

Jens, patch 1 is actually just a cleanup of msdos.c.  You could apply it
already even if you delay the decision for the other ones, so I could
stop resending it here, as patch 3 depends on it.

Philippe

[PATCH 1/5] partitions/msdos.c: end-of-line whitespace and semicolon cleanup
[PATCH 2/5] partitions: Add aix lvm partitions support files
[PATCH 3/5] partitions/msdos: enumerate also AIX LVM partitions
[PATCH 4/5] partitions/Makefile: compile aix.c if configured.
[PATCH 5/5] partitions/Kconfig: add the AIX_PARTITION entry
