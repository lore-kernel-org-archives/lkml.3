Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaIWEDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 00:03:39 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49474 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbaIWEDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 00:03:37 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, dmitry.torokhov@gmail.com, zonque@gmail.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH v2 0/2] cap1106: add support for cap11xx variants
Date: Mon, 22 Sep 2014 21:04:15 -0700
Message-Id: <1411445057-30048-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:

 * Reworked various devices support to check product id for
   respective device.
 * Added check for invalid zero channels.
 * Renamed active-high option to more clear irq-active-high
 * Use regmap_update_bits() instead of regmap_write_bits()

Matt Ranostay (2):
  cap1106: Add support for various cap11xx devices
  cap1106: support for irq-active-high option

 .../devicetree/bindings/input/cap1106.txt          |  4 ++
 drivers/input/keyboard/cap1106.c                   | 70 ++++++++++++++++------
 2 files changed, 55 insertions(+), 19 deletions(-)

-- 
1.9.1

