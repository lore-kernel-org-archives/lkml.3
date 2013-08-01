Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3HAXri (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 19:47:38 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:64080 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757880Ab3HAXrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 19:47:35 -0400
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 0/3] acpi: video: trivial cleanups
Date: Thu,  1 Aug 2013 18:43:58 -0500
Message-Id: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.8.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's a few patches to cleanup the code-style of acpi/video.c. Some were found
by checkpatch, and some just make sense.

Felipe Contreras (3):
  acpi: video: trivial costmetic cleanups
  acpi: video: trivial style cleanups
  acpi: video: remove unnecessary casting

 drivers/acpi/video.c | 210 +++++++++++++++++++++++++--------------------------
 1 file changed, 103 insertions(+), 107 deletions(-)

-- 
1.8.3.4

