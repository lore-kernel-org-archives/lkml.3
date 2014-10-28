Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaJ1UeE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 16:34:04 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45933 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJ1UeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 16:34:01 -0400
From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        linux-kernel@vger.kernel.org, Pete Popov <pete.popov@konsulko.com>,
        Dan Malek <dan.malek@konsulko.com>,
        Georgi Vlaev <georgi.vlaev@konsulko.com>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Subject: [PATCH 0/5] of: Resolver and dynamic updates
Date: Tue, 28 Oct 2014 22:33:48 +0200
Message-Id: <1414528433-9650-1-git-send-email-pantelis.antoniou@konsulko.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch-series implements a number of fixes to the
dynamic DT handling of the kernel, and provides infrastructure that
the upcoming Device Tree Overlay patchset will use.

Pantelis Antoniou (5):
  of: resolver: Switch to new local fixups format.
  of: testcases: Update with new local fixups format
  of: Only call notifiers when node is attached
  of: Add old prop argument on OF_RECONFIG_UPDATE_PROPERTY
  of: of_reconfig_get_state_change() of notifier helper.

 drivers/of/base.c                      |   9 +-
 drivers/of/dynamic.c                   | 119 ++++++++++++++++++--
 drivers/of/resolver.c                  | 191 ++++++++++++++++++++++++++++-----
 drivers/of/selftest.c                  |   2 +-
 drivers/of/testcase-data/testcases.dts |  61 ++++++-----
 include/linux/of.h                     |  21 ++--
 6 files changed, 334 insertions(+), 69 deletions(-)

-- 
1.7.12

