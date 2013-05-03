Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934456Ab3ECRMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 13:12:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46477 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934360Ab3ECRMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 13:12:09 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com> <5182AB66.6020307@linux.intel.com> <20130502194556.GB3553@gmail.com> <20130502200703.GE16684@pd.tnic> <20130503142900.GA3433@pd.tnic> <5183CFAC.8020005@infradead.org> <20130503150818.GC3433@pd.tnic> <5183D357.8000204@suse.cz> <20130503153134.GD3433@pd.tnic> <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building working KVM guest kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 03 May 2013 10:10:56 -0700
To: David Rientjes <rientjes@google.com>, Borislav Petkov <bp@alien8.de>
CC: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        linux-kernel@vger.kernel.org, penberg@kernel.org,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Message-ID: <aea679e3-048a-4f28-b164-73191095a995@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For minimal you'd probably use yes n | ...

David Rientjes <rientjes@google.com> wrote:

>On Fri, 3 May 2013, Borislav Petkov wrote:
>
>> * yes "" | make oldconfig - because we want to use the current config
>> as a base.
>> 
>
>This will select options that you don't necessarily need but default to
>
>enabled when they are selected from kvm_guest.config, so it will
>actually 
>include much more than what's needed for a kvm guest.

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
