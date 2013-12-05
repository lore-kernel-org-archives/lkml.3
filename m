Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3LEXq1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:46:27 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:50766 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754525Ab3LEXqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:46:24 -0500
Subject: [PATCH 0/2] dmi-sysfs module unload fixes
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Mike Waychison <mikew@google.com>
Date: Thu, 05 Dec 2013 16:46:16 -0700
Message-ID: <20131205234448.26412.62189.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These fix a warning on dmi-sysfs module unload and an error when
reloading immediately after unload with DEBUG_KOBJECT_RELEASE.

---

Bjorn Helgaas (2):
      firmware: dmi-sysfs: Don't remove dmi-sysfs "raw" file explicitly
      firmware: dmi-sysfs: Remove "dmi" directory on module exit


 drivers/firmware/dmi-sysfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)
