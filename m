Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3BPIhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 03:37:10 -0500
Received: from mail-ee0-f42.google.com ([74.125.83.42]:42179 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab3BPIhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 03:37:09 -0500
From: Robert Berger <git.rber@gmail.com>
To: devel@driverdev.osuosl.org, konrad.wilk@oracle.com
Cc: gregkh@linuxfoundation.org, sjenning@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, minchan@kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, git.rber@gmail.com,
        Robert Berger <rber.git@ReliableEmbeddedSystems.com>
Subject: [PATCH 0/4] staging/zache KBUILD_MODNAME, checkpatch fixes
Date: Sat, 16 Feb 2013 10:35:50 +0200
Message-Id: <1361003754-22512-1-git-send-email-rber.git@ReliableEmbeddedSystems.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <git.rber@gmail.com>
References: <git.rber@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) As per Joe's suggestion:

  "Perhaps it'd be better to use KBUILD_MODNAME all the time
  instead of adding the prefix. Also, to me mixing "ramster: "
  and "zcache: " for the prefixes is odd. Just using zcache
  all the time would be simpler, so remove namestr too."

2) Some checkpatch fixes

Robert Berger (4):
  fix: ERROR: spaces prohibited around that ':' (ctx:VxW)
  KBUILD_MODNAME and checkpatch fixes
  KBUILD_MODNAME and checkpatch fixes
  KBUILD_MODNAME instead of "ramster: "

 drivers/staging/zcache/ramster/ramster.c |   34 ++++----
 drivers/staging/zcache/ramster/tcp.c     |   36 ++++----
 drivers/staging/zcache/zbud.c            |    4 +-
 drivers/staging/zcache/zcache-main.c     |  137 ++++++++++++++----------------
 4 files changed, 103 insertions(+), 108 deletions(-)

-- 
1.7.9.5

