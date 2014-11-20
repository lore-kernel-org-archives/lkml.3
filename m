Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbaKTV3G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:29:06 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46051 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716AbaKTV3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:29:04 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, al.kochet@gmail.com
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [RFC 0/4] i2c: omap: patch series related to multimaster mode
Date: Fri, 21 Nov 2014 01:28:41 +0400
Message-Id: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is the patch series intended to improve stability of
i2c-omap driver in the i2c multimaster environments.

Tested on Beagleboard XM C.
For now all fine. No controller timeouts, no data corruptions.

Also impelemented i2c bus fault detection during startup and
after reset.

So, instead of the message "controller timeout" blaming IP,
you get "timeout waiting for bus ready".

What do think about it?

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
---
