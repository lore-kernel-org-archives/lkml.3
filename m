Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458AbaCHBd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:33:57 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:56829 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbaCHBdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:33:54 -0500
Message-ID: <531A737E.4010200@gmail.com>
Date: Sat, 08 Mar 2014 02:33:50 +0100
From: poma <pomidorabelisima@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Francois Romieu <romieu@fr.zoreil.com>
CC: netdev@vger.kernel.org, Intel Corporation <linux.nics@intel.com>,
        Mailing-List fedora-kernel <kernel@lists.fedoraproject.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>,
        "Justin M. Forbes" <jforbes@redhat.com>,
        Dan Williams <dcbw@redhat.com>, Thomas Haller <thaller@redhat.com>
Subject: Re: WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:264 dev_watchdog+0x276/0x280()
References: <530332B7.10909@gmail.com> <53043521.4060206@gmail.com> <5319059E.1010205@gmail.com> <5319F40F.4040304@gmail.com>
In-Reply-To: <5319F40F.4040304@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.03.2014 17:30, poma wrote:
> On 07.03.2014 00:32, poma wrote:
>> ...
>> After a few dozen tests with the vanilla commits, and with the same
>> amount of rawhide kernels ...
>> https://bugzilla.redhat.com/attachment.cgi?id=871694
>>
>> Dan, Francois you are both welcome with comments!
>> Thanks.
> 
> Thomas U2. :)
> 
> No barking w-dog, but now the network traffic is totally busted!
> https://bugzilla.redhat.com/attachment.cgi?id=871947
> "ping: sendmsg: No buffer space available ..."

Francois, do you have this[1] patch applicable for the recent 'r8169.c'?

$ patch -p5 < r8169-xmit.patch
patching file r8169.c
Hunk #1 FAILED at 5870.
Hunk #2 succeeded at 5540 with fuzz 2 (offset -482 lines).
Hunk #3 succeeded at 5641 (offset -494 lines).
1 out of 3 hunks FAILED -- saving rejects to file r8169.c.rej


poma


[1] https://bugzilla.kernel.org/attachment.cgi?id=125961
https://bugzilla.kernel.org/show_bug.cgi?id=14962#c37


