Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaCJVfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 17:35:39 -0400
Received: from xes-mad.com ([216.165.139.218]:32663 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754646AbaCJVfg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 17:35:36 -0400
From: Peter Tyser <ptyser@xes-inc.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Tyser <ptyser@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        James Ralston <james.d.ralston@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 7/8] mfd: lpc_ich: Add support for NM10 GPIO
Date: Mon, 10 Mar 2014 16:34:57 -0500
Message-Id: <1394487298-14459-7-git-send-email-ptyser@xes-inc.com>
X-Mailer: git-send-email 1.7.7.GIT
In-Reply-To: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
References: <1394487298-14459-1-git-send-email-ptyser@xes-inc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The NM10's GPIO is compatible with ICH v7 GPIO.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Tested-by: Dan Weinlader <danw@vs-networks.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: James Ralston <james.d.ralston@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/mfd/lpc_ich.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/lpc_ich.c b/drivers/mfd/lpc_ich.c
index cb655b3..82d70f7 100644
--- a/drivers/mfd/lpc_ich.c
+++ b/drivers/mfd/lpc_ich.c
@@ -306,6 +306,7 @@ static struct lpc_ich_info lpc_chipset_info[] = {
 	[LPC_NM10] = {
 		.name = "NM10",
 		.iTCO_version = 2,
+		.gpio_version = ICH_V7_GPIO,
 	},
 	[LPC_ICH8] = {
 		.name = "ICH8 or ICH8R",
-- 
1.7.7.GIT

