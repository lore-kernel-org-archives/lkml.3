Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3JUPGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 11:06:03 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56728 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954Ab3JUPGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 11:06:00 -0400
From: Benson Leung <bleung@chromium.org>
To: wsa@the-dreams.de, mika.westerberg@linux.intel.com, khali@linux-fr.org,
        andriy.shevchenko@linux.intel.com, jacmet@sunsite.dk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: dlaurie@chromium.org, bleung@chromium.org
Subject: [PATCH v2 0/2] i2c-designware-pci: Add Haswell ULT device support
Date: Mon, 21 Oct 2013 08:05:42 -0700
Message-Id: <1382367944-3005-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382326010-4554-1-git-send-email-bleung@chromium.org>
References: <1382326010-4554-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed 25Mhz clock instead of 100Mhz clock in 1/2 and a warning in 2/2.

[PATCH v2 1/2] i2c-designware-pci: Add Haswell ULT device IDs
[PATCH v2 2/2] i2c-designware-pci: Index Haswell ULT bus names from 0
