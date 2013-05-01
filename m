Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835Ab3EAXEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 19:04:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52726 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747Ab3EAXEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 19:04:37 -0400
Message-ID: <51819F6C.1030201@zytor.com>
Date: Wed, 01 May 2013 16:04:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        Borislav Petkov <bp@suse.de>, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
References: <tip-83aee67833071c7b73a83f7803388f7a9e481908@git.kernel.org> <alpine.DEB.2.02.1305011248220.8448@chino.kir.corp.google.com> <20130501203500.GC4466@pd.tnic> <alpine.DEB.2.02.1305011358500.19189@chino.kir.corp.google.com> <20130501211011.GD4466@pd.tnic> <alpine.DEB.2.02.1305011419020.20298@chino.kir.corp.google.com> <20130501215604.GA15623@pd.tnic> <alpine.DEB.2.02.1305011503200.3267@chino.kir.corp.google.com> <20130501222850.GB15623@pd.tnic> <alpine.DEB.2.02.1305011531320.8804@chino.kir.corp.google.com> <20130501230254.GC15623@pd.tnic>
In-Reply-To: <20130501230254.GC15623@pd.tnic>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 04:02 PM, Borislav Petkov wrote:
> On Wed, May 01, 2013 at 03:37:28PM -0700, David Rientjes wrote:
>> It means your patch is incomplete.
> 
> I'll gladly test and ack a patch which makes it complete.
> 
> Simple exercises in rhetoric about what does and what doesn't make sense
> means a rat's ass to me. You need to show me a *real* use case which you
> *actually* hit and this patch breaks it.
> 

The fundamental problem is that "select" is broken and doesn't track
dependencies of things selected.

	-hpa

