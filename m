Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbaGVX7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:59:50 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50390 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbaGVX7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 19:59:48 -0400
Date: Tue, 22 Jul 2014 16:58:02 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sasha Levin <sasha.levin@oracle.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michel Lespinasse <walken@google.com>,
        Lukas Czerner <lczerner@redhat.com>, Dave Jones <davej@redhat.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] shmem: fix faulting into a hole while it's punched,
 take 3
In-Reply-To: <53CEF197.9040600@oracle.com>
Message-ID: <alpine.LSU.2.11.1407221657150.32060@eggly.anvils>
References: <alpine.LSU.2.11.1407150247540.2584@eggly.anvils> <53C7F55B.8030307@suse.cz> <53C7F5FF.7010006@oracle.com> <53C8FAA6.9050908@oracle.com> <alpine.LSU.2.11.1407191628450.24073@eggly.anvils> <53CDD961.1080006@oracle.com> <alpine.LSU.2.11.1407220049140.1980@eggly.anvils>
 <53CEF197.9040600@oracle.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014, Sasha Levin wrote:
> On 07/22/2014 04:07 AM, Hugh Dickins wrote:
> > But there is one easy change which might do it: please would you try
> > changing the TASK_KILLABLE a few lines above to TASK_UNINTERRUPTIBLE.
> 
> That seems to have done the trick, everything works fine.

Super, thank you Sasha: patch to Andrew follows.

Hugh
