Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763058Ab3ECPHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 11:07:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45061 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762940Ab3ECPHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 11:07:32 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20130503150818.GC3433@pd.tnic>
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com> <5182AB66.6020307@linux.intel.com> <20130502194556.GB3553@gmail.com> <20130502200703.GE16684@pd.tnic> <20130503142900.GA3433@pd.tnic> <5183CFAC.8020005@infradead.org> <20130503150818.GC3433@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building working KVM guest kernels
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 03 May 2013 08:06:28 -0700
To: Borislav Petkov <bp@alien8.de>, Randy Dunlap <rdunlap@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        penberg@kernel.org, levinsasha928@gmail.com, mtosatti@redhat.com,
        tglx@linutronix.de, bp@suse.de, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Message-ID: <2b8697b5-3bbc-4ca1-808c-0adf6e6099ff@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can put a config file upstream, too.

Borislav Petkov <bp@alien8.de> wrote:

>On Fri, May 03, 2013 at 07:54:36AM -0700, Randy Dunlap wrote:
>> Could you alternately have a kvm_guest.config that should always work
>> for you?
>
>I could, and I do. The idea, however, is to have this option upstream
>so that people don't have to go search for every relevant option for
>running the kernel a kvm guest.
>
>Which reminds me: Pekka had a 'make kvmconfig' functionality in
>the kvmtool too. Which, TBH, is even better than having a Kconfig
>option with a bunch of selects. So, come to think of it, after all
>the controversy with such an option, having a 'make kvmconfig' do
>scripts/config -e <option> where <option> is in that list we select
>would be much better.
>
>This won't break randconfigs at all, btw. :-)
>
>Michal?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
