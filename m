Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaEUIya (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 04:54:30 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:45128 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbaEUIy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 04:54:28 -0400
Date: Wed, 21 May 2014 14:24:21 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>,
        Hugh Dickins <hughd@google.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Teach copy_insn() to support tmpfs
Message-ID: <20140521085421.GB29630@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20140519184054.GA6750@redhat.com>
 <20140519184136.GB6750@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20140519184136.GB6750@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052108-5816-0000-0000-00000E22D8D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2014-05-19 20:41:36]:

> tmpfs is widely used but as Denys reports shmem_aops doesn't have
> ->readpage() and thus you can't probe a binary on this filesystem.
> 
> As Hugh suggested we can use shmem_read_mapping_page() in this case,
> just we need to check shmem_mapping() if ->readpage == NULL.
> 
> Reported-by: Denys Vlasenko <dvlasenk@redhat.com>
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

-- 
Thanks and Regards
Srikar Dronamraju

