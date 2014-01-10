Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaAJJrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 04:47:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:47050 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaAJJrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 04:47:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,637,1384329600"; 
   d="scan'208";a="463090796"
Date: Fri, 10 Jan 2014 10:47:11 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [GIT] [3.13] MFD fix
Message-ID: <20140110094711.GT6003@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the 2nd MFD pull request for 3.13

It only contains one fix for the rtsx_pcr driver. Without it we see a
kernel panic on some machines, when resuming from suspend to RAM.

Thanks in advance for pulling it in.

The following changes since commit 78fd82238d0e5716578c326404184a27ba67fd6e:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-12-09 09:43:07 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git tags/mfd-fixes-3.13-2

for you to fetch changes up to 73beb63d290f961c299526852884846b0d868840:

  mfd: rtsx_pcr: Disable interrupts before cancelling delayed works (2013-12-10 12:05:37 +0100)

----------------------------------------------------------------
Thomas Gleixner (1):
      mfd: rtsx_pcr: Disable interrupts before cancelling delayed works

 drivers/mfd/rtsx_pcr.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
