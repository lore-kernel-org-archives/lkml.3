Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbaLIPsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 10:48:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066AbaLIPsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 10:48:31 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Dexuan Cui <decui@microsoft.com>
Subject: [PATCH 0/5] Tools: hv: fix compiler warnings and do minor cleanup
Date: Tue,  9 Dec 2014 16:48:18 +0100
Message-Id: <1418140103-11854-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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

 tools/hv/Makefile          |  4 ++--
 tools/hv/hv_fcopy_daemon.c | 10 ++--------
 tools/hv/hv_kvp_daemon.c   | 29 +++++++++++++----------------
 3 files changed, 17 insertions(+), 26 deletions(-)

-- 
1.9.3

