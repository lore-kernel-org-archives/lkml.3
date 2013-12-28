Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3L1P7G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 10:59:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab3L1P7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 10:59:04 -0500
Message-ID: <52BEF53E.4000704@redhat.com>
Date: Sat, 28 Dec 2013 10:58:54 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86, irq, fix logical AND/OR error in check_irq_vectors_for_cpu_disable()
References: <1387809552-20529-1-git-send-email-prarit@redhat.com> <20131224025059.GA24419@gchen.bj.intel.com> <52B989CD.6060403@redhat.com> <20131225024048.GA29542@gchen.bj.intel.com> <52BDA70C.1080508@redhat.com> <52BE244B.5040206@linux.intel.com>
In-Reply-To: <52BE244B.5040206@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 12/27/2013 08:07 PM, H. Peter Anvin wrote:
> On 12/27/2013 08:13 AM, Prarit Bhargava wrote:
>>>
>>> Back to my question, assume cpu1 will be off-lined and one irq affinity is
>>> set as (1, 2) -- this irq will be bypassed. Looks good. But if one irq
>>> affinity is set as only (1), -- this irq is bypassed, too. Not right!
>>
>> Oh, yes, this is a bug.  ... and as you point out ...
>>
> 
> Does this mean the patch that is currently in my tree should not be
> pushed to Linus?  It sounds like that to me...

Yes, hpa -- please drop the patch.  I will resubmit an updated patch after testing.

P.

> 
> 	-hpa
> 
