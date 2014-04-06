Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbaDFUPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 16:15:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8171 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752336AbaDFUPd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 16:15:33 -0400
Date: Sun, 6 Apr 2014 22:15:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/6] uprobes/x86: fix the reprel jmp/call handling
Message-ID: <20140406201524.GA32694@redhat.com>
References: <20140404185038.GA14679@redhat.com> <20140404193226.GA23092@redhat.com> <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396655065.4769.8.camel@oc7886638347.ibm.com.usor.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04, Jim Keniston wrote:
>
> On Fri, 2014-04-04 at 21:32 +0200, Oleg Nesterov wrote:
> >
> > 	1. Why insn_get_displacement() doesn't work? See "HELP!!!"
> > 	   below.
>
> insn->moffset1.value seems to be what you want.

Works! Thanks a lot.

Still I can't understand why displacement.nbytes == 0 in this case...
Nevermind.

OK. Please see the RFC changes. Obviously not for inclusion yet. And
totally untested, except I verified that the test-case from 4/6 works.

Please comment.

Oleg.

