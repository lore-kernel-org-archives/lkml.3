Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3CFHmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 02:42:00 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34254 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451Ab3CFHl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 02:41:58 -0500
From: Benson Leung <bleung@chromium.org>
To: olofj@chromium.org, miletus@chromium.org, dmitry.torokhov@gmail.com,
        matthew.garrett@nebula.com, rydberg@euromail.se, djkurtz@chromium.org,
        jy0922.shim@samsung.com, wfp5p@virginia.edu,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        platform-driver-x86@vger.kernel.org
Cc: bleung@chromium.org
Subject: [PATCH v2 0/2] Add platform data and touchpad functionality for Pixel
Date: Tue,  5 Mar 2013 23:41:45 -0800
Message-Id: <1362555707-24654-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362187254-9227-1-git-send-email-bleung@chromium.org>
References: <1362187254-9227-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for an "atmel_mxt_tp" variant in the atmel_mxt_ts.c driver.
Then, add platform data for the 224s trackpad and the 1664s touchscreen
in chromeos_laptop so that the existing version of the driver will
probe these devices correctly.

v2 : Minor bugfix in patch 1. Cleanup client_id from commit message.
     Make sure chromeos_laptop patch applies cleanly to v3.9-rc1

[PATCH v2 1/2] Input: atmel_mxt_ts - add device id for touchpad variant
[PATCH v2 2/2] Platform: x86: chromeos_laptop : Add basic platform data
