Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908AbaD1Ggn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 02:36:43 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:52596 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753704AbaD1GgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 02:36:13 -0400
Date: Mon, 28 Apr 2014 12:06:06 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] uprobes/x86: Simplify riprel_{pre,post}_xol() and
 make them similar
Message-ID: <20140428063606.GC5015@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140427165200.GA3956@redhat.com>
 <20140427165230.GA4023@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140427165230.GA4023@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042806-9332-0000-0000-000000A02437
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-04-27 18:52:30]:

> Ignoring the "correction" logic riprel_pre_xol() and riprel_post_xol()
> are very similar but look quite differently.
> 
> 1. Add the "UPROBE_FIX_RIP_AX | UPROBE_FIX_RIP_CX" check at the start
>    of riprel_pre_xol(), like the same check in riprel_post_xol().
> 
> 2. Add the trivial scratch_reg() helper which returns the address of
>    scratch register pre_xol/post_xol need to change.
> 
> 3. Change these functions to use the new helper and avoid copy-and-paste
>    under if/else branches.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

