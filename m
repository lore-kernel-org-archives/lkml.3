Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbbAUVyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 16:54:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:4623 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbbAUVyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 16:54:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,444,1418112000"; 
   d="scan'208";a="515642851"
Date: Thu, 22 Jan 2015 05:53:24 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org
Subject: [trace:ftrace/tracefs-v1 8/9] fs/tracefs/inode.c:95:31: sparse:
 symbol 'tracefs_dir_inode_operations' was not declared. Should it be static?
Message-ID: <201501220506.6s7TnZmb%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: fengguang.wu@intel.com
X-SA-Exim-Scanned: No (on bee); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git ftrace/tracefs-v1
head:   a9cda87887e46b28202c20658ad0e8de939b09cd
commit: d85d95eb1961627f3d16ced602f9653ee13ed427 [8/9] tracing: Have mkdir and rmdir be part of tracefs
reproduce:
  # apt-get install sparse
  git checkout d85d95eb1961627f3d16ced602f9653ee13ed427
  make ARCH=x86_64 allmodconfig
  make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> fs/tracefs/inode.c:95:31: sparse: symbol 'tracefs_dir_inode_operations' was not declared. Should it be static?

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
