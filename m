Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaFDQkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:40:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57165 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaFDQkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:40:39 -0400
Date: Wed, 4 Jun 2014 18:39:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt,
	minor comment updates
Message-ID: <20140604163945.GA26429@redhat.com>
References: <20140601192520.GA14539@redhat.com> <20140603182142.GA5097@gmail.com> <20140603183057.GA31382@redhat.com> <20140603183919.GC7664@gmail.com> <20140603191315.GA32736@redhat.com> <538E8FAA.7010302@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538E8FAA.7010302@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04, Masami Hiramatsu wrote:
>
> (2014/06/04 4:13), Oleg Nesterov wrote:
> > On 06/03, Ingo Molnar wrote:
> >>
> >> So exactly what do those fields do? If it's scratch register handling,
> >> would it be logical to name it arch_uprobe->scratch, or so?
> >
> > Not only, ->fixups encodes other flags. and ->ilen is used by UPROBE_FIX_CALL.
> >
> > arch_uprobe->def contains the arguments for default_xol_ops methods, currently
> > this handles everything except relative jmp/call insns.
> >
> > So perhaps ->dflt is not that ugly in this case? I simply do not see anything
> > better. But again, I agree with any name in advance.
>
> Hmm, how about ->defparam ? :)

Fine with me ;)

Ingo, will you agree with s/def/defparam/ ?

Oleg.

