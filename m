Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934431Ab3CMXvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:51:09 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47126 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932532Ab3CMXvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:51:07 -0400
From: Benson Leung <bleung@chromium.org>
To: rydberg@euromail.se, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com
Cc: bleung@chromium.org, olofj@chromium.org, djkurtz@chromium.org,
        dudl@cypress.com
Subject: [PATCH 0/4] Input: cyapa - Add firmware update feature
Date: Wed, 13 Mar 2013 16:50:47 -0700
Message-Id: <1363218651-22457-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a feature to update trackpad firmware via request_firmware to cyapa.
The last patch in the series adds sysfs attributses useful for version
and product identification that a user mode utility will need to
keep track of the current firmware on the device.

This is used today on Chromebook systems with cypress trackpads:
Samsung Series 5 550 Chromebook
Acer C7
HP Pavilion 14
Samsung Chromebook (2012, ARM version)

[PATCH 1/4] Input: cyapa - Move common initialization to cyapa_detect
[PATCH 2/4] Input: cyapa - Firmware update via request firmware
[PATCH 3/4] Input: cyapa - Allow filename to be changed in update_fw
[PATCH 4/4] Input: cyapa - Add sysfs attrs for product_id and fw_version
