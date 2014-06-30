Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaF3Qi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:38:57 -0400
Received: from ns.gsystem.sk ([62.176.172.50]:44054 "EHLO ns.gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbaF3Qiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:38:55 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Samuel Chessman <chessman@tux.org>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/11 v3] tlan: Link handling improvements and Olicom fixes
Date: Mon, 30 Jun 2014 18:38:26 +0200
Message-Id: <1404146317-3094-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch series improves link handling in tlan driver, allowing the
cable to be (un)plugged anytime and NetworkManager to work properly.

Also there are some bugfixes related to Olicom OC-2326 card.

---
 tlan.c |  224 ++++++++++++++++++++++++++++++++++++++---------------------------
 tlan.h |    5 -
 2 files changed, 134 insertions(+), 95 deletions(-)


-- 
Ondrej Zary
