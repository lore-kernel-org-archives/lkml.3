Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaLXRXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 12:23:04 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51981 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbaLXRXB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 12:23:01 -0500
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: <linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 0/3] PM / OPP: Cleanup a little bit of a bitrot
Date: Wed, 24 Dec 2014 11:22:54 -0600
Message-ID: <1419441777-25651-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is a little usual to see with multiple contributors that file tends to loose
a consistent feel. So, try and fix it up in this trivial change series - no
functional changes at all.


based on v3.19-rc1 tag

Nishanth Menon (3):
  PM / OPP: export dev_pm_opp_get_notifier
  PM / OPP: Ensure consistent naming of static functions
  PM / OPP: Update kernel documentation

 drivers/base/power/opp.c |  190 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 146 insertions(+), 44 deletions(-)

-- 
1.7.9.5

