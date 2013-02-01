Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab3BAWfA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 17:35:00 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:44511 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757913Ab3BAWe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 17:34:58 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, olofj@chromium.org, olof@lixom.net
Subject: [PATCH 0/4] Platform: x86: chromeos_laptop - Add more x86 Chromebooks
Date: Fri,  1 Feb 2013 14:34:42 -0800
Message-Id: <1359758086-2320-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series will add support for the following devices on
the following laptops:

Acer C7 Chromebook - Cypress APA Smbus Trackpad
Acer AC700 - Taos tsl2563 light sensor
Samsung Series 5 Chromebook - Taos tsl2583 light sensor
Cr-48 - Taos tsl2563 light sensor

Cheers,
Benson

