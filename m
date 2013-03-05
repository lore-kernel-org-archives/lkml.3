Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab3CEEya (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 23:54:30 -0500
Received: from mail.active-venture.com ([67.228.131.205]:57841 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3CEEy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 23:54:29 -0500
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Mon, 04 Mar 2013 22:54:28 -0600
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-watchdog@vger.kernel.org
Cc: Wim Van Sebroeck <wim@iguana.be>, linux-kernel@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 0/8] watchdog: w83627hf: Convert to watchdog infrastructure
Date: Mon,  4 Mar 2013 20:54:11 -0800
Message-Id: <1362459259-9733-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to watchdog infrastructure, cleanup, add support for additional
chips, and merge with W83697HF and W83697UG watchdog drivers.

Tested with NCT6775 and NCT6776. I'll be able to test the code with W83627UHG.
Additional test feedback, especially for other chips, would be appreciated.
