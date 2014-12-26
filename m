Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaLZUor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 15:44:47 -0500
Received: from mail-oi0-f54.google.com ([209.85.218.54]:50762 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaLZUop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 15:44:45 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 1/2] MAINTAINERS: drop DT regex matching on of_get_property and of_match_table
Date: Fri, 26 Dec 2014 14:43:55 -0600
Message-Id: <1419626636-7130-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

The regex matching on of_get_property and of_match_table cause Grant and
me to be copied on loads of drivers as well as be listed as maintainers
of those drivers. I believe the intent here was to check for documenting
of properties, but that has proven horribly ineffective. checkpatch now
at least partially covers this checking compatible strings. So remove
these regex's to reduce the firehose somewhat.

Cc: Grant Likely <grant.likely@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
---
 MAINTAINERS | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..fa9ae27 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -696,7 +696,7 @@ L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 W:	http://blackfin.uclinux.org/
 S:	Supported
 F:	sound/soc/blackfin/*
- 
+
 ANALOG DEVICES INC IIO DRIVERS
 M:	Lars-Peter Clausen <lars@metafoo.de>
 M:	Michael Hennerich <Michael.Hennerich@analog.com>
@@ -6983,8 +6983,6 @@ S:	Maintained
 F:	drivers/of/
 F:	include/linux/of*.h
 F:	scripts/dtc/
-K:	of_get_property
-K:	of_match_table
 
 OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS
 M:	Rob Herring <robh+dt@kernel.org>
-- 
2.1.0

