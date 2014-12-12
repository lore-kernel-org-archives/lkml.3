Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935068AbaLLTY4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:24:56 -0500
Received: from mga03.intel.com ([134.134.136.65]:30870 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934913AbaLLTYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:24:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="497955095"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] two more pstore commits for merge window
Date: Fri, 12 Dec 2014 11:24:54 -0800
Message-Id: <548b41063017714840@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 069fb0b63722f8c9f8b4bbce236793626c89af33:

  syslog: Provide stub check_syslog_permissions (2014-11-17 10:28:04 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux.git tags/please-pull-morepstore

for you to fetch changes up to 027bc8b08242c59e19356b4b2c189f2d849ab660:

  pstore-ram: Allow optional mapping with pgprot_noncached (2014-12-11 13:38:31 -0800)

----------------------------------------------------------------
Couple of pstore-ram enhancements to allow use of different memory attributes

----------------------------------------------------------------
Rob Herring (1):
      pstore-ram: Fix hangs by using write-combine mappings

Tony Lindgren (1):
      pstore-ram: Allow optional mapping with pgprot_noncached

 Documentation/ramoops.txt  | 13 +++++++++++--
 fs/pstore/ram.c            | 13 +++++++++++--
 fs/pstore/ram_core.c       | 31 ++++++++++++++++++++++---------
 include/linux/pstore_ram.h |  4 +++-
 4 files changed, 47 insertions(+), 14 deletions(-)
