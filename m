Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162AbaCERKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:10:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41622 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaCERKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:10:53 -0500
Message-ID: <53175A73.2070204@oracle.com>
Date: Wed, 05 Mar 2014 10:10:11 -0700
From: Khalid Aziz <khalid.aziz@oracle.com>
Organization: Oracle Corp
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, peterz@infradead.org,
        akpm@linux-foundation.org, andi.kleen@intel.com, rob@landley.net,
        viro@zeniv.linux.org.uk, venki@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] [PATCH] Pre-emption control for userspace
References: <1393870033-31076-1-git-send-email-khalid.aziz@oracle.com> <20140304135624.GA6846@redhat.com> <53161116.9050109@oracle.com> <20140304190348.GA22075@redhat.com> <5316343B.2030404@oracle.com> <20140305143800.GA29480@redhat.com> <20140305161227.GA1713@redhat.com>
In-Reply-To: <20140305161227.GA1713@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 09:12 AM, Oleg Nesterov wrote:
> On 03/05, Oleg Nesterov wrote:
>>
>> You added /proc/sched_preempt_delay to avoid the syscall. I think it
>> would be better to simply add vdso_sched_preempt_delay() instead.
>
> I am stupid. vdso_sched_preempt_delay() obviously can't write to, say,
> task_struct.
>
> Oleg.
>

That is easy to miss :) I had looked into vdso when I started but found 
out I can't use vdso for this.

--
Khalid
