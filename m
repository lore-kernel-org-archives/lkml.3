Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaFBOPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 10:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbaFBOPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 10:15:01 -0400
Date: Mon, 2 Jun 2014 16:14:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Hugh Dickins <hughd@google.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: tmpfs support
Message-ID: <20140602141406.GA17863@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

Based on tip:perf/uprobes


Usually I try to accumulate more changes before I ask to pull, but v3.15
is close and it would be nice to merge the tmpfs fix too. Plus a purely
cosmetic change I promised to do when we discussed the x86 changes.

Oleg Nesterov (3):
      uprobes: Shift ->readpage check from __copy_insn() to uprobe_register()
      uprobes: Teach copy_insn() to support tmpfs
      uprobes/x86: Rename arch_uprobe->def to ->dflt, minor comment updates

 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |   37 ++++++++++++++++++-------------------
 kernel/events/uprobes.c        |   17 +++++++++++------
 3 files changed, 30 insertions(+), 26 deletions(-)

