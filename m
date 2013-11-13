Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757689Ab3KMFW6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 00:22:58 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:33786 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3KMFWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 00:22:51 -0500
Date: Wed, 13 Nov 2013 10:52:33 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] uprobes: Add uprobe_task->dup_work/dup_addr
Message-ID: <20131113052233.GI2559@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131108190003.GA12755@redhat.com>
 <20131111071151.GA2559@linux.vnet.ibm.com>
 <20131111165543.GA12233@redhat.com>
 <20131112174302.GH2559@linux.vnet.ibm.com>
 <20131112192038.GA7748@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20131112192038.GA7748@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13111305-8236-0000-0000-000003BAC24A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-11-12 20:20:38]:

> On 11/12, Srikar Dronamraju wrote:
> >
> > Okay, moving to arch_uprobe_task is fine. I probably got confused by
> > "First of all it is not really needed,"
> 
> OK, this doesn't look good, I agree.
> 
> Please see v2 below, I tried to improve the changelog.
> 
> > > OK. How about dup_xol_work/dup_xol_vaddr ?
> >
> > Yes fine with me.
> 
> Done.
> 
> I added your ack optimistically, please let me know if you think I
> should change something else.

Looks nice to me.

-- 
Thanks and Regards
Srikar Dronamraju

