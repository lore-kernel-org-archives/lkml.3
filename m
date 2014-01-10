Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbaAJKuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:50:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42653 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032AbaAJKuL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:50:11 -0500
Date: Fri, 10 Jan 2014 11:50:08 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] APM
Message-ID: <alpine.LNX.2.00.1401101148220.9087@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael,

please consider pulling

  git://git.kernel.org/pub/scm/linux/kernel/git/jikos/apm.git for-next

into linux-pm.git, to receive:


- addition of hibernation events to apm-emulation, from Bin Shi


Thanks.

Bin Shi (1):
      apm-emulation: add hibernation APM events to support suspend2disk

 drivers/char/apm-emulation.c  |   11 +++++++++--
 include/uapi/linux/apm_bios.h |    2 ++
 2 files changed, 11 insertions(+), 2 deletions(-)

-- 
Jiri Kosina
SUSE Labs
