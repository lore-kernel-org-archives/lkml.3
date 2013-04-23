Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910Ab3DWUvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 16:51:05 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:51622
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293Ab3DWUvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 16:51:04 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/5] Tools: hv: snapshot
Date: Tue, 23 Apr 2013 14:23:30 -0700
Message-Id: <1366752210-318-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These five patches were sent by Olaf a while ago. Greg wanted these
re-submitted. I have tested these patches.

Olaf Hering (5):
  Tools: hv: fix warnings in hv_vss_daemon
  tools: hv: fix checks for origin of netlink message in hv_vss_daemon
  tools: hv: use getmntent in hv_vss_daemon
  tools: hv: use FIFREEZE/FITHAW in hv_vss_daemon
  tools: hv: skip iso9660 mounts in hv_vss_daemon

 tools/hv/hv_vss_daemon.c |   78 +++++++++++++++++++++++++++++++---------------
 1 files changed, 53 insertions(+), 25 deletions(-)

-- 
1.7.4.1

