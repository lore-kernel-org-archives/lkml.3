Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934094Ab3HHCxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:53:07 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:38117 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934079Ab3HHCxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:53:03 -0400
Message-ID: <5203098F.908@linux.vnet.ibm.com>
Date: Thu, 08 Aug 2013 08:29:27 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        konrad.wilk@oracle.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH  V12 0/14] Paravirtualized ticket spinlocks
References: <20130806114020.20643.57235.sendpatchset@codeblue.in.ibm.com> <52016412.1020608@zytor.com> <5201B6FB.5080807@linux.vnet.ibm.com> <5201D180.9080005@zytor.com> <5201ED01.7000803@linux.vnet.ibm.com>
In-Reply-To: <5201ED01.7000803@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080802-9264-0000-0000-000004495F48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 12:15 PM, Raghavendra K T wrote:
> On 08/07/2013 10:18 AM, H. Peter Anvin wrote:
>> tip:master is not a stable branch; it is more like linux-next.  We need
>> to figure out which topic branches are dependencies for this set.
>
> Okay. I 'll start looking at the branches that would get affected.
> (Xen, kvm are obvious ones).
> Please do let me know the branches I might have to check for.

On Linus tree,
I am seeing patch getting applied to arch/x86/Kconfig at some offset

Hunk #1 succeeded at 632 (offset -31 lines).
Hunk #2 succeeded at 657 (offset -31 lines).

since patches are based on -rc4, Xen, kvm should not have problem
as pointed by Gleb, Konrad.
I did not see change in tip's jumplabel/core-spinlock tree that would
affect it.

Peter, could you please point me to the conflict, so that I can help
there which saves time and trouble to maintainers.


