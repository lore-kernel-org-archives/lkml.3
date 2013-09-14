Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab3INROD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 13:14:03 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:38273 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3INROB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 13:14:01 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 00/11] Convert more drivers to use devm_hwmon_device_register_with_groups
Date: Sat, 14 Sep 2013 10:13:41 -0700
Message-Id: <1379178832-1489-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The jc42 driver is compile tested only. All other patches were tested
with real hardware.

The patches apply on top of the previously submitted patches introducing
hwmon_device_register_with_groups and devm_hwmon_device_register_with_groups.
