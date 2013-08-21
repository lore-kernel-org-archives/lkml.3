Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab3HUIlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:41:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3HUIlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:41:21 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: [3.5.y.z extended stable] Linux 3.5.7.20
Date: Wed, 21 Aug 2013 09:41:16 +0100
Message-Id: <1377074477-31306-1-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am announcing the release of the Linux 3.5.7.20 kernel.

The updated 3.5.y tree can be found at: 
  git://kernel.ubuntu.com/ubuntu/linux.git linux-3.5.y
and can be browsed at:
  http://kernel.ubuntu.com/git?p=ubuntu/linux.git;h=refs/heads/linux-3.5.y;a=shortlog

The diff from v3.5.7.19 is posted as a follow-up to this email.

The 3.5.y extended stable tree is maintained by the Ubuntu Kernel Team.
For more info, see https://wiki.ubuntu.com/Kernel/Dev/ExtendedStable

 -Luis

-- 
 Makefile                                    |  2 +-
 drivers/net/wireless/iwlegacy/common.c      |  2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |  2 +-
 drivers/net/wireless/rt2x00/rt2x00config.c  |  2 +-
 include/net/mac80211.h                      | 10 ++++++++--
 net/mac80211/driver-trace.h                 |  6 ++++--
 net/mac80211/ieee80211_i.h                  |  2 ++
 net/mac80211/mlme.c                         | 15 ++++++++-------
 net/mac80211/scan.c                         |  3 ++-
 9 files changed, 28 insertions(+), 16 deletions(-)

Johannes Berg (1):
      mac80211: add time synchronisation with BSS for assoc

Luis Henriques (1):
      Linux 3.5.7.20

