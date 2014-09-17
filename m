Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916AbaIQVsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:48:24 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:43316 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787AbaIQVsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:48:22 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] eeepc cleanup
Date: Wed, 17 Sep 2014 23:47:18 +0200
Message-Id: <1410990447-3210-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the second installment cleaning up some things in the eeepc laptop
driver.

This depends on "eeepc-laptop: simplify parse_arg()".

For those interested, I keep a copy based on Darren's testing branch on
github:

	https://github.com/fransklaver/linux.git tags/eeepc_cleanup_v2

v1..v2:
  - squash coding style fixes
  - drop patch moving to file permission macros, in favor of
  - move towards better sysfs api usage
  - drop changes to existing sysfs return values

Frans Klaver (9):
  eeepc-laptop: clean up coding style
  eeepc-laptop: change sysfs function names to API expectations
  eeepc-laptop: use DEVICE_ATTR* to instantiate device_attributes
  eeepc-laptop: pull out ACPI_STORE_FUNC and ACPI_SHOW_FUNC macros
  eeepc-laptop: tell sysfs that the disp attribute is write-only
  eeepc-laptop: pull out SENSOR_STORE_FUNC and SENSOR_SHOW_FUNC macros
  eeepc-laptop: make fan1_input really read-only
  eeepc-laptop: check proper return values in get_cpufv
  eeepc-laptop: store_cpufv: return error if set_acpi fails

 drivers/platform/x86/eeepc-laptop.c | 117 ++++++++++++++++++------------------
 1 file changed, 59 insertions(+), 58 deletions(-)

-- 
2.1.0

