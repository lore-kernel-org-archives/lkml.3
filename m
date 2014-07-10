Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbaGJMqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 08:46:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37667 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaGJMqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 08:46:33 -0400
Message-ID: <53BE8B1B.3000808@oracle.com>
Date: Thu, 10 Jul 2014 08:46:19 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        davej@redhat.com, koct9i@gmail.com, lczerner@redhat.com,
        stable@vger.kernel.org, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + shmem-fix-faulting-into-a-hole-while-its-punched-take-2.patch
 added to -mm tree
References: <53b45c9b.2rlA0uGYBLzlXEeS%akpm@linux-foundation.org> <53BCBF1F.1000506@oracle.com> <alpine.LSU.2.11.1407082309040.7374@eggly.anvils> <53BD1053.5020401@suse.cz> <53BD39FC.7040205@oracle.com> <53BD67DC.9040700@oracle.com> <alpine.LSU.2.11.1407092358090.18131@eggly.anvils>
In-Reply-To: <alpine.LSU.2.11.1407092358090.18131@eggly.anvils>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 03:37 AM, Hugh Dickins wrote:
> I do think that the most useful thing you could do at the moment,
> is to switch away from running trinity on -next temporarily, and
> run it instead on Linus's current git or on 3.16-rc4, but with
> f00cdc6df7d7 reverted and my "take 2" inserted in its place.
> 
> That tree would also include Heiko's seq_buf_alloc() patch, which
> trinity on -next has cast similar doubt upon: at present, we do
> not know if Heiko's patch and my patch are bad in themselves,
> or exposing other bugs in 3.16-rc, or exposing bugs in -next.

Funny enough, Linus's tree doesn't even boot properly here. It's
going to take longer than I expected...


Thanks,
Sasha
