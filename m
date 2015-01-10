Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751361AbbAJFGH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 00:06:07 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:36545
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750724AbbAJFGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 00:06:05 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        vkuznets@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 0/5] Tools: hv: fix compiler warnings and do minor cleanup 
Date: Fri,  9 Jan 2015 22:18:10 -0800
Message-Id: <1420870690-2223-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When someone does 'make' in tools/hv/ issues appear:
- hv_fcopy_daemon is not being built;
- lots of compiler warnings.

This is just a cleanup. Compile-tested by myself on top of linux-next/master.

Piggyback this series and send "[PATCH 5/5] Tools: hv: do not add redundant '/'
in hv_start_fcopy()"

Vitaly Kuznetsov (5):
  Tools: hv: add mising fcopyd to the Makefile
  Tools: hv: remove unused bytes_written from kvp_update_file()
  Tools: hv: address compiler warnings for hv_kvp_daemon.c
  Tools: hv: address compiler warnings for hv_fcopy_daemon.c
  Tools: hv: do not add redundant '/' in hv_start_fcopy()

 tools/hv/Makefile          |    4 ++--
 tools/hv/hv_fcopy_daemon.c |   10 ++--------
 tools/hv/hv_kvp_daemon.c   |   29 +++++++++++++----------------
 3 files changed, 17 insertions(+), 26 deletions(-)

-- 
1.7.4.1

