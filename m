Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932530Ab3EBRcR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:32:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34190 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775Ab3EBRcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:32:16 -0400
Message-ID: <5182A300.9050603@zytor.com>
Date: Thu, 02 May 2013 10:31:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
References: <20130501203500.GC4466@pd.tnic> <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com> <20130501211011.GD4466@pd.tnic> <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com> <20130501215604.GA15623@pd.tnic> <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com> <20130501222850.GB15623@pd.tnic> <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com> <20130501230254.GC15623@pd.tnic> <51819F6C.1030201@zytor.com> <20130502070633.GA26361@gmail.com>
In-Reply-To: <20130502070633.GA26361@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 12:06 AM, Ingo Molnar wrote:
> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> On 05/01/2013 04:02 PM, Borislav Petkov wrote:
>>> On Wed, May 01, 2013 at 03:37:28PM -0700, David Rientjes wrote:
>>>> It means your patch is incomplete.
>>>
>>> I'll gladly test and ack a patch which makes it complete.
>>>
>>> Simple exercises in rhetoric about what does and what doesn't make 
>>> sense means a rat's ass to me. You need to show me a *real* use case 
>>> which you *actually* hit and this patch breaks it.
>>
>> The fundamental problem is that "select" is broken and doesn't track 
>> dependencies of things selected.
> 
> The way I've been solving it in a similar usecase was to select the 
> required options - plus its dependencies, manually.
> 
> That should be possible here as well, driven by any weird randconfig build 
> failures that get found. Such a set of selects quickly converges.
> 

The problem is that it is a moving target.  We really need a
dependency-resolving version of select.

	-hpa


