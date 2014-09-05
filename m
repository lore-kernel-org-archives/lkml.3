Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302AbaIEMUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:20:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932151AbaIEMUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:20:09 -0400
Date: Fri, 5 Sep 2014 14:17:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 1/3] uprobes: add comment with insn opcodes, mnemonics
	and why we dont support them
Message-ID: <20140905121732.GA26662@redhat.com>
References: <1409839951-8073-1-git-send-email-dvlasenk@redhat.com> <20140904142454.GA5237@redhat.com> <CAK1hOcMM_79Uz=xms=BQu6BsrDLRmAaXUs_s-qOj-N0e-+qezA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcMM_79Uz=xms=BQu6BsrDLRmAaXUs_s-qOj-N0e-+qezA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05, Denys Vlasenko wrote:
>
> On Thu, Sep 4, 2014 at 4:24 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > Does this replace the previous series (which at first glance looks
> > pretty much the same) ?
>
> All 5 patches (two patch sets)

FYI, I obvoiuosly can't take the 1st series which changes lib/insn.c ;)

> I sent yesterday are resends.

OK, and the changes in arch/x86/kernel/uprobes.c (2nd series) were acked
by Jim in the past.

Oleg.

