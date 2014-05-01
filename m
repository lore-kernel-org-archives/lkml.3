Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaEAAI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 20:08:27 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33158 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaEAAI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 20:08:26 -0400
Subject: Re: [PATCH 3/3] uprobes/x86: Simplify riprel_{pre,post}_xol() and
 make them similar
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140428063606.GC5015@linux.vnet.ibm.com>
References: <20140427165200.GA3956@redhat.com>
	 <20140427165230.GA4023@redhat.com>
	 <20140428063606.GC5015@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Apr 2014 17:08:10 -0700
Message-ID: <1398902890.4878.26.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050100-5806-0000-0000-000024C3F24C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-28 at 12:06 +0530, Srikar Dronamraju wrote:
> * Oleg Nesterov <oleg@redhat.com> [2014-04-27 18:52:30]:
> 
> > Ignoring the "correction" logic riprel_pre_xol() and riprel_post_xol()
> > are very similar but look quite differently.
> > 
> > 1. Add the "UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX" check at the start
> >    of riprel_pre_xol(), like the same check in riprel_post_xol().
> > 
> > 2. Add the trivial scratch_reg() helper which returns the address of
> >    scratch register pre_xol/post_xol need to change.
> > 
> > 3. Change these functions to use the new helper and avoid copy-and-paste
> >    under if/else branches.
> > 
> > Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> 
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> 
Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>

