Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaJLCrt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 22:47:49 -0400
Received: from linuxhacker.ru ([217.76.32.60]:38365 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752262AbaJLCr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 22:47:26 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Cc: Oleg Drokin <green@linuxhacker.ru>
Subject: [PATCH 0/3] Lustre: remove old compat code
Date: Sat, 11 Oct 2014 22:46:51 -0400
Message-Id: <1413082014-10510-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These three patches remove support for code that is no longer needed.
Mostly ability to talk to old version of lustre clients and servers.

Oleg Drokin (3):
  staging/lustre/ptlrpc: get rid of lustre 1.8 compatible checksums
  staging/lustre: get rid of deprecaed acl mount option code
  staging/lustre/quota: Get rid of compat quota code

 drivers/staging/lustre/lustre/include/lustre_net.h |  5 --
 drivers/staging/lustre/lustre/llite/dir.c          | 58 ----------------------
 .../staging/lustre/lustre/llite/llite_internal.h   | 18 -------
 drivers/staging/lustre/lustre/llite/llite_lib.c    | 19 -------
 .../staging/lustre/lustre/ptlrpc/pack_generic.c    | 26 ----------
 drivers/staging/lustre/lustre/ptlrpc/sec_null.c    | 18 -------
 6 files changed, 144 deletions(-)

-- 
1.9.3

