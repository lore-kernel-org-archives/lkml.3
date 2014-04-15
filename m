Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaDOMiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:38:17 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:64693 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706AbaDOMiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:38:04 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 0/2 v3] cfg80211: The very first steps to support 5/10MHz channels in 5.9Ghz band
Date: Tue, 15 Apr 2014 14:37:54 +0200
Message-Id: <1397565476-4348-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The IEEE 802.11p amendment specifies usage of 5 and 10 MHz wide
channels in 5.9GHz band for vehicular environment. This patch-set
adds new channel attributes holding the information about the
prohibited bandwidths. This is meant to be used mainly with
channels in 5.9GHz band in future implementation of 802.11p.

Changes since v2:
 * Rebased to jberg/mac80211-next
 * Squashed patches 1+2

Rostislav Lisovy (2):
  cfg80211: Add attributes describing prohibited channel bandwidth
  cfg80211: Use 5MHz bandwidth by default when checking usable channels

 include/net/cfg80211.h       |  6 ++++++
 include/uapi/linux/nl80211.h |  6 ++++++
 net/wireless/chan.c          |  2 ++
 net/wireless/nl80211.c       | 13 +++++++++++++
 net/wireless/reg.c           | 22 +++++++++++++++-------
 5 files changed, 42 insertions(+), 7 deletions(-)

-- 
1.9.2

