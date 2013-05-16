Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3EPUFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 16:05:23 -0400
Received: from vms173025pub.verizon.net ([206.46.173.25]:46569 "EHLO
	vms173025pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3EPUFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 16:05:19 -0400
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 May 2013 16:05:19 EDT
From: Corey Minyard <cminyard@mvista.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 0/4] ipmi: Some minor fixes
Date: Thu, 16 May 2013 14:04:23 -0500
Message-id: <1368731067-31404-1-git-send-email-cminyard@mvista.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some minor fixes I had queued up.  The last one came in recently (patch 4) 
and it and patch 2 are candidates for stable-kernel.

