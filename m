Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283Ab3KEDst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 22:48:49 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:65191 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3KEDss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 22:48:48 -0500
From: Azael Avalos <coproscefalo@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>, linux-kernel@vger.kernel.org
Cc: azael.avalos@gmail.com
Subject: [PATCH 0/8] toshiba_acpi: New features added and a fix
Date: Mon,  4 Nov 2013 20:48:37 -0700
Message-Id: <1383623325-4004-1-git-send-email-coproscefalo@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Up for review, the following patch series add new features
found on newer Toshiba laptops.

The first two fix an illumination detection bug, so consider
applying those to stable.

The rest just add support for touchpad, accelerometer axes,
keyboard backlight and ECO led, plus platform support, bumping
the version to 0.20.

These apply cleanly to Matthew's platform tree and with
just some fuzz to next tree.

[PATCH 1/8] toshiba_acpi: Add System Configuration Interface (SCI)
[PATCH 2/8] toshiba_acpi: Adapt illumination_* code to use the new SCI
[PATCH 3/8] toshiba_acpi: Add platform support
[PATCH 4/8] toshiba_acpi: Add kbd backlight support and sysfs files
[PATCH 5/8] toshiba_acpi: Add ECO led support
[PATCH 6/8] toshiba_acpi: Add accelerometer support
[PATCH 7/8] toshiba_acpi: Add touchpad enable/disable support
[PATCH 8/8] toshiba_acpi: Update version and copyright information


Saludos
Azael

