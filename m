Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbaILXHK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 19:07:10 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:49170 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaILXHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 19:07:07 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/13] eeepc-laptop cleanups
Date: Sat, 13 Sep 2014 01:06:39 +0200
Message-Id: <1410563212-31565-1-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the first version of a patch series following discussion [1]. The series
applies on top of "eeepc-laptop: simplify parse_arg()"[2]. This also includes
some cleanups that weren't in the original discussion, but should probably be
taken into account.

[1] https://lkml.org/lkml/2014/9/3/865
[2] https://lkml.org/lkml/2014/9/10/742

For those interested, a proper branch is available at:
	https://github.com/fransklaver/linux wip/eeepc_cleanup_v1

Frans Klaver (13):
  eeepc-laptop: coding style: fix indentation
  eeepc-laptop: coding style: add curly braces around else compound
  eeepc-laptop: coding style: add curly braces around else compound
  eeepc-laptop: use symbolic permissions in device attributes
  eeepc-laptop: use DEVICE_ATTR to instantiate device_attributes
  eeepc-laptop: pull out ACPI_STORE_FUNC and ACPI_SHOW_FUNC macros
  eeepc-laptop: make disp attribute really write-only
  eeepc-laptop: pull out SENSOR_STORE_FUNC and SENSOR_SHOW_FUNC macros
  eeepc-laptop: make fan1_input really read-only
  eeepc-laptop: compare proper return values in get_cpufv
  eeepc-laptop: propagate errors from get_cpufv
  eeepc-laptop: store_cpufv: return error if set_acpi fails
  eeepc-laptop: return -ENXIO if acpi getter or setter fails

 drivers/platform/x86/eeepc-laptop.c | 118 +++++++++++++++++++-----------------
 1 file changed, 62 insertions(+), 56 deletions(-)

-- 
2.1.0

