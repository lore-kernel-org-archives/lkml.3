Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaAFQX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 11:23:26 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:52357 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754769AbaAFQXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 11:23:23 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Thomas Renninger <trenn@suse.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: [PATCH 0/3] cpupower tools: trivial cleanup
Date: Mon,  6 Jan 2014 21:53:22 +0530
Message-Id: <1389025405-3463-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.2.227.g53f3478
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just had a chance to look at cpupower; here's a small contribution.

Thanks.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>

Ramkumar Ramachandra (3):
  cpupower tools: adjust README to reflect rename
  cpupower tools: update README
  cpupower tools: update uninstall target

 tools/power/cpupower/Makefile |  8 ++++++--
 tools/power/cpupower/README   | 24 +++++++++++-------------
 tools/power/cpupower/ToDo     |  1 -
 3 files changed, 17 insertions(+), 16 deletions(-)

-- 
1.8.5.2.227.g53f3478

