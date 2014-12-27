Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751445AbaL0Lby (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 06:31:54 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:36594 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaL0Lbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 06:31:52 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        silverhammermba@gmail.com, Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH 0/2] input: synaptics - make image sensors report finger widths
Date: Sat, 27 Dec 2014 12:31:27 +0100
Message-Id: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Image sensors were not reporting finger widths despite being able to do
it. These patches will make sure that finger widths are always reported.

Gabriele Mazzotta (2):
  input: synaptics - make image sensors report ABS_MT_TOUCH_MAJOR
  input: synaptics - fix width calculation on image sensors

 drivers/input/mouse/synaptics.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

-- 
2.1.4

