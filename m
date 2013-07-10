Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3GJIco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 04:32:44 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:50591 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab3GJIcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 04:32:42 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: linux-iio@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Srinivas Pandruvada <srinivas.pandruvada@intel.com>
Subject: [PATCH 0/4] iio: hid-sensor: add module alias for autoload
Date: Wed, 10 Jul 2013 10:31:56 +0200
Message-Id: <1373445120-5407-1-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.1.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm not sure if it was by intention that none of the hid-sensor drivers
were loaded automatically. But I assume it was not by intention.

Therefor I've added a module alias to every hid-sensor driver by adding
a MODULE_DEVICE_TABLE.

This has another benefit: it makes it possible to use a normale driver name.

Therefor I've changed all driver names to KBUILD_MODNAME instead of
HID-SENSOR-2000xx as the later isn't very descriptive when starring at
kernel messages.

Regards,

Alexander Holler

