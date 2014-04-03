Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaDCQdw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:33:52 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:49410 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaDCQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:33:47 -0400
Date: Thu, 3 Apr 2014 22:03:40 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] uprobes/x86: Kill the "ia32_compat" check in
 handle_riprel_insn(), remove "mm" arg
Message-ID: <20140403163340.GC4882@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140331194337.GA9257@redhat.com>
 <20140331194405.GA9290@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140331194405.GA9290@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040316-8878-0000-0000-00000BA0B3B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-03-31 21:44:05]:

> Kill the "mm->context.ia32_compat" check in handle_riprel_insn(), if
> it is true insn_rip_relative() must return false. validate_insn_bits()
> passed "ia32_compat" as !x86_64 to insn_init(), and insn_rip_relative()
> checks insn->x86_64.
> 
> Also, remove the no longer needed "struct mm_struct *mm" argument and
> the unnecessary "return" at the end.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
-- 
Thanks and Regards
Srikar Dronamraju

