Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763372Ab3ECTJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:09:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:5881 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763294Ab3ECTJk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:09:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,606,1363158000"; 
   d="scan'208";a="297222215"
Message-ID: <51840B70.2000205@linux.intel.com>
Date: Fri, 03 May 2013 12:09:36 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        penberg@kernel.org, levinsasha928@gmail.com, mtosatti@redhat.com,
        tglx@linutronix.de, bp@suse.de, fengguang.wu@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com> <5182AB66.6020307@linux.intel.com> <20130502194556.GB3553@gmail.com> <20130502200703.GE16684@pd.tnic> <20130503142900.GA3433@pd.tnic> <5183CFAC.8020005@infradead.org> <20130503150818.GC3433@pd.tnic> <5183D357.8000204@suse.cz> <20130503153134.GD3433@pd.tnic> <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com> <aea679e3-048a-4f28-b164-73191095a995@email.android.com> <alpine.DEB.2.02.1305031016290.32047@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1305031016290.32047@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 10:19 AM, David Rientjes wrote:
> 
> Works fine unless kvm_guest.config enables an option that requires a 
> numbered choice, such as CONFIG_EXPERT enabling the the ability to select 
> CONFIG_SLOB from the list of allocators.  Instead of relying on yes(1), 
> I think you'll need to modify this custom script to explicitly disable 
> remaining options and select the default when there's a choice.
> 

Actually it is called:

KCONFIG_ALLCONFIG=kvm_guest.config make allnoconfig

	-hpa

