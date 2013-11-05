Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab3KERua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 12:50:30 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:40820 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750925Ab3KERu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 12:50:28 -0500
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>,
        Ionut Nicu <ioan.nicu.ext@nsn.com>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 0/5] OF: Fixes in preperation of DT overlays
Date: Tue,  5 Nov 2013 19:50:11 +0200
Message-Id: <1383673816-29293-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset introduces a number of fixes that are required
for the subsequent patches that add DT overlays support.

Most of them are trivial, adding small bits that are missing,
or exporting functions that were private before.

Pantelis Antoniou (5):
  OF: Clear detach flag on attach
  OF: Introduce device tree node flag helpers.
  OF: export of_property_notify
  OF: Export all DT proc update functions
  OF: Introduce utility helper functions

 drivers/of/Makefile |   2 +-
 drivers/of/base.c   |  77 ++++++++--------
 drivers/of/util.c   | 253 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/of.h  | 119 ++++++++++++++++++++++++
 4 files changed, 413 insertions(+), 38 deletions(-)
 create mode 100644 drivers/of/util.c

-- 
1.7.12

