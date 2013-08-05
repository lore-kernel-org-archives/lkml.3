Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab3HEMk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:40:57 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36623 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab3HEMk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:40:56 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com
Subject: [PATCH v6] linux,stdout-path helper
Date: Mon,  5 Aug 2013 14:40:43 +0200
Message-Id: <1375706445-15375-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.8.4.rc0
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following adds a helper for matching the linux,stdout-path property
in the chosen node and makes use of it in the i.MX serial

This is a series originally created by me. It was hijacked and then abandoned
by Jean-Christophe for v5. I reverted the changes by Jean-Christophe since
they introduced changes to the devicetree binding. Instead I'd like to have
the existing binding implemented first before changing it.

Sascha

changes since v5:
- reverted changes from v4
- parse linux,stdoutpath property in of_alias_scan as suggested by Grant
changes since v4:
- add option support and check stdout-path too
changes since v3:
- move code from separate files to drivers/of/base.c and include/linux/of.h
changes since v2:
- move helper to OF core and make it independent of serial devices
changes since v1:
- move it out of the i.MX serial driver and make it generic for serial devices.

