Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731AbaJ2E3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 00:29:50 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:35615 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaJ2E3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 00:29:49 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, oleg.drokin@intel.com, andreas.dilger@intel.com,
        heenasirwani@gmail.com, bergwolf@gmail.com, amir.shehata@intel.com,
        gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/02] staging:lustre:lnet:selftest: fix sparse warnings
Date: Wed, 29 Oct 2014 08:29:43 +0400
Message-Id: <cover.1414517099.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch fix simple sparse warnings: make functions static and remove
unused code. I'm doing only little testing: module was loaded properly,
output of lst without real server is the same as before.

Anton Saraev (2):
  staging:lustre:lnet:selftest: fix sparse warnings
  staging:lustre:lnet:selftest: remove unused function

 drivers/staging/lustre/lnet/selftest/conctl.c    | 34 ++++++++--------
 drivers/staging/lustre/lnet/selftest/conrpc.c    | 20 +++++-----
 drivers/staging/lustre/lnet/selftest/framework.c | 50 ++++++++++++------------
 drivers/staging/lustre/lnet/selftest/module.c    | 15 +------
 drivers/staging/lustre/lnet/selftest/rpc.c       | 34 ++++++++--------
 drivers/staging/lustre/lnet/selftest/timer.c     |  8 ++--
 6 files changed, 75 insertions(+), 86 deletions(-)

-- 
1.9.1

