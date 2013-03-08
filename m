Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab3CHDnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 22:43:45 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:36096 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3CHDnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 22:43:43 -0500
From: Benson Leung <bleung@chromium.org>
To: torvalds@linux-foundation.org, olofj@chromium.org, miletus@chromium.org,
        dmitry.torokhov@gmail.com, matthew.garrett@nebula.com,
        rydberg@euromail.se, djkurtz@chromium.org, jy0922.shim@samsung.com,
        wfp5p@virginia.edu, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Cc: bleung@chromium.org, davem@davemloft.net
Subject: [PATCH v3 0/2] Add platform data and touchpad functionality for Pixel
Date: Thu,  7 Mar 2013 19:43:32 -0800
Message-Id: <1362714214-32405-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362187254-9227-1-git-send-email-bleung@chromium.org>
References: <1362187254-9227-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for a touchpad variant in the atmel_mxt_ts driver.
Then, add platform data for the 224s trackpad and the 1664s touchscreen
in chromeos_laptop so that the existing version of the driver will
probe these devices correctly.

v3 : Add platform data for is_tp and key_map. Remove dependence on
     device name for tp behavior.
v2 : Minor bugfix in patch 1. Cleanup client_id from commit message.
     Make sure chromeos_laptop patch applies cleanly to v3.9-rc1

[PATCH v3 1/2] Input: atmel_mxt_ts - Support for touchpad variant
[PATCH v3 2/2] Platform: x86: chromeos_laptop : Add basic platform data
