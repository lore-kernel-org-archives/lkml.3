Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932514AbaDHQ2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:28:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932459AbaDHQ2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:28:54 -0400
Date: Tue, 8 Apr 2014 18:28:50 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] uprobes/x86: fix the reprel jmp/call handling
Message-ID: <20140408162850.GC31460@redhat.com>
References: <20140404185038.GA14679@redhat.com> <20140404193226.GA23092@redhat.com> <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com> <20140406201524.GA32694@redhat.com> <5343E0E3.70808@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5343E0E3.70808@hitachi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08, Masami Hiramatsu wrote:
>
> (2014/04/07 5:15), Oleg Nesterov wrote:
> >
> > Still I can't understand why displacement.nbytes == 0 in this case...
> > Nevermind.
>
> I guess that you misunderstanding what the displacement means.

You are kidding ;) It is not that I misunderstood ->displacement in
particular, so far I understand almost nothing in this area!

> insn->displacement means
> [... snip ...]

Thanks a lot for your explanation,

> In that case, you should use insn->immediate, instead of insn->moffset1

OK... bu I'm afraid I'll ask a stupid question before I update this
series accordinly.

Thanks.

Oleg.

