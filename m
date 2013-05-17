Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab3EQE6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:58:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59230 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750972Ab3EQE6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:58:36 -0400
From: Joe Perches <joe@perches.com>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] BusLogic: Message logging neatening
Date: Thu, 16 May 2013 21:58:29 -0700
Message-Id: <cover.1368765873.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1368754556.git.khalid.aziz@oracle.com>
References: <cover.1368754556.git.khalid.aziz@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you're going through the trouble to fix this CamelCase stuff
and make it work on 64 bit, how about a little more cleanup?

Joe Perches (3):
  BusLogic: Add __printf verification, fix fallout
  BusLogic: Coalesce formats with multiple string fragments
  BusLogic: Use more conventional argument order for logging

 drivers/scsi/BusLogic.c | 304 ++++++++++++++++++++++++------------------------
 drivers/scsi/BusLogic.h |  23 ++--
 2 files changed, 161 insertions(+), 166 deletions(-)

-- 
1.8.1.2.459.gbcd45b4.dirty

