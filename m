Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaFCSbv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:31:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbaFCSbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:31:50 -0400
Date: Tue, 3 Jun 2014 20:30:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes/x86: Rename arch_uprobe->def into ->dflt,
	minor comment updates
Message-ID: <20140603183057.GA31382@redhat.com>
References: <20140601192520.GA14539@redhat.com> <20140603182142.GA5097@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603182142.GA5097@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Ingo Molnar wrote:
>
> * Oleg Nesterov <oleg@redhat.com> wrote:
>
> > --- a/arch/x86/include/asm/uprobes.h
> > +++ b/arch/x86/include/asm/uprobes.h
> > @@ -52,7 +52,7 @@ struct arch_uprobe {
> >  		struct {
> >  			u8	fixups;
> >  			u8	ilen;
> > -		} 			def;
> > +		} 			dflt;
>
> Pls lts nt use slly abbrvtns, ok?

OK. As I said in the previous dicussion, I agree with any naming.

> How about arch_uprobe->default?

And this is how it was named when I wrote this code. Unfortunately gcc
dislikes this name ;) So I renamed it to ->def. Then I was asked to
rename it and I agree, ->def doesn't look good.

Could you suggest something better?

Oleg.

