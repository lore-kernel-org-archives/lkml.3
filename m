Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaFEJ24 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 05:28:56 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:59492 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaFEJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 05:28:55 -0400
Date: Thu, 5 Jun 2014 11:28:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Re: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt,
 minor comment updates
Message-ID: <20140605092850.GA4632@gmail.com>
References: <20140601192520.GA14539@redhat.com>
 <20140603182142.GA5097@gmail.com>
 <20140603183057.GA31382@redhat.com>
 <20140603183919.GC7664@gmail.com>
 <20140603191315.GA32736@redhat.com>
 <538E8FAA.7010302@hitachi.com>
 <20140604163945.GA26429@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140604163945.GA26429@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@redhat.com> wrote:

> On 06/04, Masami Hiramatsu wrote:
> >
> > (2014/06/04 4:13), Oleg Nesterov wrote:
> > > On 06/03, Ingo Molnar wrote:
> > >>
> > >> So exactly what do those fields do? If it's scratch register handling,
> > >> would it be logical to name it arch_uprobe->scratch, or so?
> > >
> > > Not only, ->fixups encodes other flags. and ->ilen is used by UPROBE_FIX_CALL.
> > >
> > > arch_uprobe->def contains the arguments for default_xol_ops methods, currently
> > > this handles everything except relative jmp/call insns.
> > >
> > > So perhaps ->dflt is not that ugly in this case? I simply do not see anything
> > > better. But again, I agree with any name in advance.
> >
> > Hmm, how about ->defparam ? :)
> 
> Fine with me ;)
> 
> Ingo, will you agree with s/def/defparam/ ?

Certainly! :)

Thanks,

	Ingo
