Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759642Ab3HNJoN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 05:44:13 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44631 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3HNJoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 05:44:09 -0400
Message-ID: <520B52D8.5040105@linux.vnet.ibm.com>
Date: Wed, 14 Aug 2013 15:20:16 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, jeremy@goop.org, konrad.wilk@oracle.com,
        gleb@redhat.com, pbonzini@redhat.com, gregkh@suse.de,
        peterz@infradead.org, tglx@linutronix.de, agraf@suse.de,
        riel@redhat.com, avi.kivity@gmail.com, habanero@linux.vnet.ibm.com,
        chegu_vinod@hp.com, ouyang@cs.pitt.edu, drjones@redhat.com,
        attilio.rao@citrix.com, linux-doc@vger.kernel.org,
        torvalds@linux-foundation.org, kvm@vger.kernel.org,
        andi@firstfloor.org, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        stefano.stabellini@eu.citrix.com, mtosatti@redhat.com,
        srivatsa.vaddagiri@gmail.com,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Suzuki Poulose <suzuki@in.ibm.com>
Subject: Re: [PATCH delta V13 14/14] kvm : Paravirtual ticketlocks support
 for linux guests running on KVM hypervisor
References: <y> <1376058122-8248-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <1376058122-8248-15-git-send-email-raghavendra.kt@linux.vnet.ibm.com> <20130810193849.GA25260@linux.vnet.ibm.com> <520A620B.6070702@zytor.com> <20130813165552.GA6795@gmail.com> <20130813200211.GA27811@linux.vnet.ibm.com>
In-Reply-To: <20130813200211.GA27811@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081409-1618-0000-0000-000004734D3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 01:32 AM, Raghavendra K T wrote:
>
> Ingo, below delta patch should fix it, IIRC, I hope you will be folding this
> back to patch 14/14 itself. Else please let me.
> I have already run allnoconfig, allyesconfig, randconfig with below patch. But will
> test again.

I Did 2 more runs of allyesconfig, allnoconfig, and 40 runs of
randconfig. patchset with the fix looking good now.

