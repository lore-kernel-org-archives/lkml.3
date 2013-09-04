Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934594Ab3IDMhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 08:37:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932217Ab3IDMhe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:37:34 -0400
From: Daniel Borkmann <dborkman@redhat.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 0/2] prandom_u32_range, prandom_u32_max helpers
Date: Wed,  4 Sep 2013 14:37:25 +0200
Message-Id: <1378298247-29364-1-git-send-email-dborkman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
  - migrated api to random.h, ccing lkml
  - dropped second patch for now

Daniel Borkmann (2):
  random: add prandom_u32_range and prandom_u32_max helpers
  net: migrate direct users to prandom_u32_max

 drivers/net/team/team_mode_random.c |  8 +-------
 include/linux/random.h              | 31 ++++++++++++++++++++++++++++++-
 include/net/red.h                   |  2 +-
 net/802/garp.c                      |  3 ++-
 net/802/mrp.c                       |  3 ++-
 net/packet/af_packet.c              |  2 +-
 net/sched/sch_choke.c               |  8 +-------
 7 files changed, 38 insertions(+), 19 deletions(-)

-- 
1.7.11.7

