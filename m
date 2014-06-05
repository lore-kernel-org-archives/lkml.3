Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaFEOeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:34:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbaFEOeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:34:11 -0400
Date: Thu, 5 Jun 2014 16:33:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [GIT PULL] uprobes: tmpfs support (Was: uprobes/x86: Rename
	arch_uprobe->def into ->dflt, minor comment updates)
Message-ID: <20140605143307.GA24982@redhat.com>
References: <20140601192520.GA14539@redhat.com> <20140603182142.GA5097@gmail.com> <20140603183057.GA31382@redhat.com> <20140603183919.GC7664@gmail.com> <20140603191315.GA32736@redhat.com> <538E8FAA.7010302@hitachi.com> <20140604163945.GA26429@redhat.com> <20140605092850.GA4632@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140605092850.GA4632@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 06/04, Masami Hiramatsu wrote:
> > >
> > > Hmm, how about ->defparam ? :)
> >
> > Fine with me ;)
> >
> > Ingo, will you agree with s/def/defparam/ ?
>
> Certainly! :)

Great ;) I updated this patch in uprobes/core, please pull from

  git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc uprobes/core

based on tip:perf/uprobes


Oleg Nesterov (3):
      uprobes: Shift ->readpage check from __copy_insn() to uprobe_register()
      uprobes: Teach copy_insn() to support tmpfs
      uprobes/x86: Rename arch_uprobe->def to ->defparam, minor comment updates

 arch/x86/include/asm/uprobes.h |    2 +-
 arch/x86/kernel/uprobes.c      |   37 ++++++++++++++++++-------------------
 kernel/events/uprobes.c        |   17 +++++++++++------
 3 files changed, 30 insertions(+), 26 deletions(-)

