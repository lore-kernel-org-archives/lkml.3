Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab3JKAvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:51:39 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:56869 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756381Ab3JKAvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:51:37 -0400
Date: Fri, 11 Oct 2013 06:21:28 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: [PATCH] UPROBES: Remove useless __weak attribute
Message-ID: <20131011005128.GA2199@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131009120809.GN1615@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131009120809.GN1615@linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101100-5806-0000-0000-000023071E57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ralf Baechle <ralf@linux-mips.org> [2013-10-09 14:08:09]:

> <linux/uprobes.h> declares arch_uprobe_skip_sstep() as a weak function.
> But as there is no definition of generic version so when trying to build
> uprobes for an architecture that doesn't yet have a arch_uprobe_skip_sstep()
> implementation, the vmlinux will try to call arch_uprobe_skip_sstep()
> somehwere in Stupidhistan leading to a system crash.  We rather want a
> proper link error so remove arch_uprobe_skip_sstep().
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Will be nice to have another arch(mips) support for uprobes. 

-- 
Thanks and Regards
Srikar Dronamraju

