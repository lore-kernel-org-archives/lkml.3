Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab3KKIIP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 03:08:15 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39901 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3KKIIB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 03:08:01 -0500
Date: Mon, 11 Nov 2013 13:37:21 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uprobes/powerpc: Kill arch_uprobe->ainsn
Message-ID: <20131111080721.GC2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131109175350.GA17412@redhat.com>
 <20131109175409.GA17437@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131109175409.GA17437@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111108-5806-0000-0000-0000235FCBFF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-11-09 18:54:09]:

> powerpc has both arch_uprobe->insn and arch_uprobe->ainsn to
> make the generic code happy. This is no longer needed after
> the previous change, powerpc can just use "u32 insn".
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

