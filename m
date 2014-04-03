Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaDCQer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 12:34:47 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58313 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaDCQei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 12:34:38 -0400
Date: Thu, 3 Apr 2014 22:04:30 +0530
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
Subject: Re: [PATCH 6/7] uprobes/x86: move the UPROBE_FIX_{RIP,IP,CALL} code
 at the end of pre/post hooks
Message-ID: <20140403163430.GD4882@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140331194337.GA9257@redhat.com>
 <20140331194412.GA9304@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140331194412.GA9304@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040316-6102-0000-0000-00000540B308
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-03-31 21:44:12]:

> No functional changes. Preparation to simplify the review of the next
> change. Just reorder the code in arch_uprobe_pre/post_xol() functions
> so that UPROBE_FIX_{RIP_*,IP,CALL} logic goes to the end.
> 
> Also change arch_uprobe_pre_xol() to use utask instead of autask, to
> make the code more symmetrical with arch_uprobe_post_xol().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
-- 
Thanks and Regards
Srikar Dronamraju

