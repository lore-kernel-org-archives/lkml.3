Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbaD2KG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 06:06:26 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40649 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbaD2KGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 06:06:25 -0400
Date: Tue, 29 Apr 2014 15:36:11 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uprobes/x86: Make good_insns_* depend on CONFIG_X86_*
Message-ID: <20140429100611.GD3269@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140419170104.GA30667@redhat.com>
 <20140419170159.GA30867@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140419170159.GA30867@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042910-8878-0000-0000-00000C2CCEC6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-04-19 19:01:59]:

> Add the suitable ifdef's around good_insns_* arrays. We do not want
> to add the ugly ifdef's into their only user, uprobe_init_insn(), so
> the "#else" branch simply defines them as NULL. This doesn't generate
> the extra code, gcc is smart enough, although the code is fine even if
> it could not detect that (without CONFIG_IA32_EMULATION) is_64bit_mm()
> is __builtin_constant_p().
> 
> The patch looks more complicated because it also moves good_insns_64
> up close to good_insns_32.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
-- 
Thanks and Regards
Srikar Dronamraju

