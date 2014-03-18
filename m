Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaCRWPu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 18:15:50 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:60951 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723AbaCRWPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 18:15:46 -0400
Message-ID: <5328C585.6070100@linaro.org>
Date: Tue, 18 Mar 2014 18:15:33 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        davem@davemloft.net, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] uprobes: Add uprobes support for ARM
References: <1394223040-17129-1-git-send-email-dave.long@linaro.org> <531F5799.2070302@linaro.org> <20140317235229.GQ21483@n2100.arm.linux.org.uk>
In-Reply-To: <20140317235229.GQ21483@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/14 19:52, Russell King - ARM Linux wrote:
> On Tue, Mar 11, 2014 at 02:36:09PM -0400, David Long wrote:
>>    git://git.linaro.org/people/dave.long/linux.git uprobes-v7
>>
>> for you to fetch changes up to e55c35236b8adf79453a998506ec6081833b9484:
>>
>>    ARM: add uprobes support (2014-03-11 11:40:29 -0400)
>
> I pulled this a week ago into my devel-testing (which is unpublished),
> and while it hasn't shown any signs of functional problems, I was just
> about to merge it into devel-stable when I noticed the history.
>
> This is based upon:
>
> Merge branch 'for-next' of git://git.samba.org/sfrench/cifs-2.6
> + Linux 3.11
> + Merge branch 'perf-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> + Linux 3.12-rc5
> + Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net
> + Linux 3.13-rc3
> + Linux 3.13-rc4
> + Linux 3.13-rc8
> + Linux 3.14-rc2
> + Linux 3.14-rc4
> + Linux 3.14-rc5
> |
> [your uprobes patches]
>
> where each + is a merge of the named commit into the previous.  This is
> the kind of thing which will make Linus quite unhappy: please base
> patches off a plain -rc release, not off a merge commit.
>
> I'm sure there's others on the mailing list who can guide you on this
> point, but I do need to ask you to re-spin without those merges.  I'm
> happy to take a respin of it provided it's based on 3.14-rc5 (so I can
> more easily confirm that there aren't any changes which I haven't
> already tested.)

OK, I consulted with a couple coworkers and the fix for this was 
particularly easy.  The respun branch is in place now.  Same repo, same 
branch name, based on v3.14-rc5.  Sorry for the newbie mistake.

I'm assuming a new git-pull request is not required (until I hear 
otherwise).

> Thanks, and sorry about the lateness of this email.
>

I'm just back Monday night from a few days vacation, so your timing was 
perfect for me.

-dl

