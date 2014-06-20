Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934917AbaFTP4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 11:56:30 -0400
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:33872 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755218AbaFTPrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 11:47:52 -0400
From: Martin Gumbrecht <martin.gumbrecht@googlemail.com>
To: gregkh@linuxfoundation.org
Cc: christian.bay@studium.fau.de, linux-kernel@i4.cs.fau.de,
        lisa@xenapiadmin.com, daeseok.youn@gmail.com, luiorpe1@gmail.com,
        veeableful@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, martin.gumbrecht@googlemail.com
Subject: [PATCH v2 0/7] Staging: bcm: checkpatch fixes 
Date: Fri, 20 Jun 2014 17:37:57 +0200
Message-Id: <1403278684-10891-1-git-send-email-martin.gumbrecht@googlemail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch sereies fixes several errors and warnings shown by the checkpatch script at the module driver/staging/bcm

v2 splits the patches up, so that only one kind of fix is made in each patch.
In addition also fixes on a third file (Qos.c) are included in this version.

v1 was sent in by Christian Bay <christian.bay@studium.fau.de>


Martin Gumbrecht (7):
  Staging: bcm: Prototypes.h: fix checkpatch errors: blank lines
  Staging: bcm: Prototypes.h: fix checkpatch errors: whitespaces
  Staging: bcm: Queue.h: fix checkpatch errors: comments
  Staging: bcm: Queue.h: fix checkpatch errors: brackets
  Staging: bcm: Queue.h: fix checkpatch errors: whitespaces
  Staging: bcm: Qos.c: fix checkpatch errors: comments
  Staging: bcm: Qos.c: fix checkpatch errors: whitespaces

 drivers/staging/bcm/Prototypes.h |  89 +++++++++++++--------------
 drivers/staging/bcm/Qos.c        | 126 ++++++++++++++++++++++-----------------
 drivers/staging/bcm/Queue.h      |  46 +++++++-------
 3 files changed, 134 insertions(+), 127 deletions(-)

-- 
1.9.1

