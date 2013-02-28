Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3B1JIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:08:52 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:48604 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751737Ab3B1JIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:08:49 -0500
Date: Thu, 28 Feb 2013 10:08:46 +0100
To: linux-kernel@vger.kernel.org
Cc: tj@kernel.org
Subject: WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
Message-ID: <20130228090846.GA249@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Froe: Markus Trippelsdorf <markus@trippelsdorf.de>
From: markus@trippelsdorf.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just hit the following warning on current git tree:

------------[ cut here ]------------
WARNING: at lib/idr.c:678 idr_find_slowpath+0x97/0xc0()
Hardware name: System Product Name
Pid: 12366, comm: okular Not tainted 3.8.0-09633-g2a7d2b9-dirty #312
Call Trace:
 [<ffffffff8105b7a0>] ? warn_slowpath_common+0x60/0xa0
 [<ffffffff811bf557>] ? idr_find_slowpath+0x97/0xc0
 [<ffffffff811249f2>] ? inotify_idr_find_locked+0x32/0x80
 [<ffffffff810ecf7d>] ? fput+0x1d/0xc0
 [<ffffffff811254d0>] ? sys_inotify_rm_watch+0x50/0xc0
 [<ffffffff814c9f58>] ? int_signal+0x12/0x17
 [<ffffffff814c9d52>] ? system_call_fastpath+0x16/0x1b
---[ end trace be8364dcbafab6c6 ]---

-- 
Markus
