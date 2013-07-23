Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab3GWCni (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 22:43:38 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:49885 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab3GWCne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 22:43:34 -0400
Message-ID: <51EDEF86.9040405@linux.vnet.ibm.com>
Date: Tue, 23 Jul 2013 08:20:46 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: gleb@redhat.com, mingo@redhat.com, jeremy@goop.org, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, linux-doc@vger.kernel.org,
        habanero@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
        peterz@infradead.org, mtosatti@redhat.com,
        stefano.stabellini@eu.citrix.com, andi@firstfloor.org,
        attilio.rao@citrix.com, ouyang@cs.pitt.edu, gregkh@suse.de,
        agraf@suse.de, chegu_vinod@hp.com, torvalds@linux-foundation.org,
        avi.kivity@gmail.com, tglx@linutronix.de, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, riel@redhat.com, drjones@redhat.com,
        virtualization@lists.linux-foundation.org,
        srivatsa.vaddagiri@gmail.com
Subject: Re: [PATCH RFC V11 0/18] Paravirtualized ticket spinlocks
References: <20130722061631.24737.75508.sendpatchset@codeblue> <20130722193627.GP30300@phenom.dumpdata.com>
In-Reply-To: <20130722193627.GP30300@phenom.dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072302-9574-0000-0000-000008D5C3F8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 01:06 AM, Konrad Rzeszutek Wilk wrote:
>>
>> github link: https://github.com/ktraghavendra/linux/tree/pvspinlock_v11
>
> And chance you have a backup git tree? I get:
>
> This repository is temporarily unavailable.

I only have it on local apart from there :(.
Hope it was a temporary github problem. working for me now.

>
>>
>> Please note that we set SPIN_THRESHOLD = 32k with this series,
>> that would eatup little bit of overcommit performance of PLE machines
>> and overall performance of non-PLE machines.
>>
>> The older series[3] was tested by Attilio for Xen implementation.
>>
>> Note that Konrad needs to revert below two patches to enable xen on hvm
>>    70dd4998, f10cd522c
>
> We could add that to the series. But let me first test it out - and that
> gets back to the repo :-)
>

okay.

