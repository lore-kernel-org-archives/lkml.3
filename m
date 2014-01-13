Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaAMSNB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 13:13:01 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42258 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751590AbaAMSM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 13:12:58 -0500
Message-ID: <52D42C99.6050505@sgi.com>
Date: Mon, 13 Jan 2014 10:12:41 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>
Subject: Re: [PATCH 0/3] : KGDB/KDB/UV updates.
References: <20131018185334.272062791@asylum.americas.sgi.com> <20131019085617.GA9717@gmail.com>
In-Reply-To: <20131019085617.GA9717@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/19/2013 1:56 AM, Ingo Molnar wrote:
> 
> * Mike Travis <travis@sgi.com> wrote:
> 
>>
>> * Change the fix for KDB not defined build problem by changing
>>   the kgdb_nmicallin() interface to include the KDB specific
>>   reason code.  This removes a dependency on KDB in the debug
>>   core.  Also requires a change the call in from UV NMI handler.
>>
>> * Fix some problems found by the kbuild test robot.
>>
>> * Fix UV call into kgdb to depend only on whether KGDB is defined
>>   and not both KGDB and KDB.  This allows the power nmi command
>>   to use the gdb remote connection if enabled.  Note new action
>>   of 'kgdb' needs to be set as well to indicate user wants to
>>   wait for gdb to be connected.  If it's set to 'kdb' then an
>>   error message is displayed if KDB is not configured.
>> --
> 
> This looks better.
> 
> Jason, any objections?
> 
> Thanks,
> 
> 	Ingo
> 

I haven't heard anything back about this update.  Were there
objections?  Looks like another merge window is closing?

Thanks,
Mike

