Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab3BUUPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:15:14 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:40649 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab3BUUPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:15:11 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, miletus@chromium.org
Subject: [PATCH 0/6] Platform: x86: chromeos_laptop - Add support for Chromebook Pixel
Date: Thu, 21 Feb 2013 12:14:54 -0800
Message-Id: <1361477700-26342-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series will add support for the isl light sensor,
atmel mxt touchpad, and atmel mxt touchscreen on the Chromebook Pixel.

[PATCH 1/6] Platform: x86: chromeos_laptop - add i915 gmbuses to
[PATCH 2/6] Platform: x86: chromeos_laptop - Add a more general
[PATCH 3/6] Platform: x86: chromeos_laptop - Add isl light sensor for
[PATCH 4/6] Platform: x86: chromeos_laptop - Add support for probing
[PATCH 5/6] Platform: x86: chromeos_laptop - Add Pixel Trackpad
[PATCH 6/6] Platform: x86: chromeos_laptop - Add Pixel Touchscreen

This should be merged after the patch adding the HP Pavilion 14.
Platform: x86: chromeos_laptop - Add HP Pavilion 14

