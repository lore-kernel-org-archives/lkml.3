Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab3LJOOH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 09:14:07 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:37911 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753383Ab3LJOOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 09:14:04 -0500
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
Subject: [PATCH 0/3] OF: kobj-ification fixes
Date: Tue, 10 Dec 2013 16:13:50 +0200
Message-Id: <1386684833-24112-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent patchset by Grant converted the DT dynamic interface from /proc
to using sysfs.

This patchset addresses various problems that come up when using it as a
base for the subsequent dynamic overlays patches.

Pantelis Antoniou (3):
  of: Fix early OF builtup on kobj-ification
  OF: Add a allnodes pointer back to the tree
  OF: kobj ops should only happen on attached nodes

 drivers/of/base.c  | 112 ++++++++++++++++++++++++++++++++++++++++-------------
 drivers/of/fdt.c   |  10 +++--
 include/linux/of.h |   1 +
 3 files changed, 94 insertions(+), 29 deletions(-)

-- 
1.7.12

