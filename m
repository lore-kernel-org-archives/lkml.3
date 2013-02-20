Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935547Ab3BTPFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:05:47 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24924 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935383Ab3BTPFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:05:45 -0500
Message-ID: <5124E628.3020008@oracle.com>
Date: Wed, 20 Feb 2013 10:05:12 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: peterz@infradead.org, jamie.iles@oracle.com, penberg@kernel.org,
        acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [liblockdep] Re: [PATCH v2 01/11] liblockdep: remove the need
 for liblockdep_init
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com> <20130219075825.GA3741@gmail.com>
In-Reply-To: <20130219075825.GA3741@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 02:58 AM, Ingo Molnar wrote:
> 
> * Sasha Levin <sasha.levin@oracle.com> wrote:
> 
>> Use a constructor in the library instead of making the user manually
>> call liblockdep_init().
>>
>> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>> ---
>>  tools/lib/lockdep/common.c                    | 2 +-
>>  tools/lib/lockdep/include/liblockdep/common.h | 1 -
>>  tools/lib/lockdep/tests/AA.c                  | 1 -
>>  tools/lib/lockdep/tests/ABBA.c                | 1 -
>>  tools/lib/lockdep/tests/ABBCCA.c              | 1 -
>>  tools/lib/lockdep/tests/ABBCCDDA.c            | 1 -
>>  tools/lib/lockdep/tests/ABCABC.c              | 1 -
>>  tools/lib/lockdep/tests/ABCDBCDA.c            | 1 -
>>  tools/lib/lockdep/tests/ABCDBDDA.c            | 1 -
>>  tools/lib/lockdep/tests/WW.c                  | 1 -
>>  tools/lib/lockdep/tests/unlock_balance.c      | 1 -
>>  tools/lib/lockdep/uinclude/linux/lockdep.h    | 1 -
>>  12 files changed, 1 insertion(+), 12 deletions(-)
> 
> Note that due to the heavy objections in the kvmtool thread I 
> have removed the tools/lib/lockdep library and tooling commits 
> from the locking tree - to be able to merge the other locking 
> commits upstream.

Understood.

> I'm pretty sad about this outcome as your code really brought 
> new development life into lockdep - if you still want to pursue 
> this approach then you might want to try it via the tools/kvm 
> tree, or via a separate project.

I'm most likely to just fold it into a standalone project since
I'm not quite certain the purpose of tools/ at this point.


Thanks,
Sasha

