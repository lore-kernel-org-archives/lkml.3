Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbaJ2Tl6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 15:41:58 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50785 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaJ2Tl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 15:41:57 -0400
From: Anton Saraev <antonysaraev@gmail.com>
To: gregkh@linuxfoundation.org
Cc: antonysaraev@gmail.com, oleg.drokin@intel.com, andreas.dilger@intel.com,
        heenasirwani@gmail.com, bergwolf@gmail.com, amir.shehata@intel.com,
        gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 00/02] staging:lustre:lnet:selftest: fix sparse warnings
Date: Wed, 29 Oct 2014 23:41:48 +0400
Message-Id: <cover.1414609881.git.antonysaraev@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I can understand warning in previous series is about unused function
(I don't see other differences in output of make with C=1, W=1 and W=2).
I remove "static" for lnet_selftest_structure_assertion from
first patch. Maybe I should merge patches in one but I think that
addition of static declaration and deletion of function should be in two
different patches. So the second patch depends on the first...

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

