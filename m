Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaIUDAg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 23:00:36 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:57446 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbaIUDAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 23:00:33 -0400
From: Matt Ranostay <mranostay@gmail.com>
To: galak@codeaurora.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        zonque@gmail.com, robh+dt@kernel.org
Cc: devicetree@vger.kernel.org, Matt Ranostay <mranostay@gmail.com>
Subject: [PATCH 0/3] cap1106: add support for cap11xx variants
Date: Sat, 20 Sep 2014 20:01:06 -0700
Message-Id: <1411268469-21283-1-git-send-email-mranostay@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enable using cap11xx devices that have different
number of capacitance channels, and using active-high on the
interrupt output.

Matt Ranostay (3):
  cap1106: Add support for various cap11xx devices
  cap1106: support for active-high interrupt option
  dt: cap1106 active-high property addition

 .../devicetree/bindings/input/cap1106.txt          |  4 ++
 drivers/input/keyboard/cap1106.c                   | 58 ++++++++++++----------
 2 files changed, 35 insertions(+), 27 deletions(-)

-- 
1.9.1

