Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758777Ab3BGO3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 09:29:36 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:45022 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab3BGO3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 09:29:35 -0500
Message-ID: <5113BA36.206@oracle.com>
Date: Thu, 07 Feb 2013 09:29:10 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: mingo@kernel.org, peterz@infradead.org, jamie.iles@oracle.com,
        penberg@kernel.org, acme@ghostprotocols.net, paulus@samba.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/11] liblockdep: preload helper
References: <1360188694-25077-1-git-send-email-sasha.levin@oracle.com> <1360188694-25077-12-git-send-email-sasha.levin@oracle.com> <8738x8sjdz.fsf@sejong.aot.lge.com>
In-Reply-To: <8738x8sjdz.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 01:55 AM, Namhyung Kim wrote:
> On Wed,  6 Feb 2013 17:11:34 -0500, Sasha Levin wrote:
>> diff --git a/tools/lib/lockdep/lockdep b/tools/lib/lockdep/lockdep
>> new file mode 100755
>> index 0000000..616bf9a
>> --- /dev/null
>> +++ b/tools/lib/lockdep/lockdep
>> @@ -0,0 +1,3 @@
>> +#! /bin/bash
>> +
>> +LD_PRELOAD=liblockdep.so "$@"
> 
> Just try to be more conservative ;-)
> 
>   LD_PRELOAD="liblockdep.so $LD_PRELOAD" "$@"

Will do, thanks!

And yes, it's supposed to be 'lockdep perf' :


Thanks,
Sasha

