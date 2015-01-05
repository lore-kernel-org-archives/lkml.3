Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbbAEW2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:28:48 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:61856 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752973AbbAEW2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:28:47 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: linux-input@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-kernel@vger.kernel.org, silverhammermba@gmail.com,
        peter.hutterer@who-t.net, hdegoede@redhat.com,
        benjamin.tissoires@gmail.com,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH v2 0/4] input: synaptics - report correct width and pressure values
Date: Mon,  5 Jan 2015 23:28:31 +0100
Message-Id: <1420496915-31560-1-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make image sensors and cr48 sensors report widths and fix the
calculation of width and pressure values in some cases.

Changes since v1:
 - Rebased on 35393dcb2ed3
 - Get widths from AGM packets too
 - Include support for cr48 sensors
 - Fix pressure values on image sensors

Gabriele Mazzotta (4):
  input: synaptics - fix pressure values calculation on image sensors
  input: synaptics - fix width values calculation on image sensors
  input: synaptics - change default width value of cr48 sensors
  input: synaptics - make semi-mt touchpads report widths

 drivers/input/mouse/synaptics.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

-- 
2.1.4

