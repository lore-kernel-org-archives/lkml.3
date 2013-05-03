Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab3ECQxZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 12:53:25 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:37349 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab3ECQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 12:53:24 -0400
Date: Fri, 3 May 2013 09:53:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Borislav Petkov <bp@alien8.de>
cc: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@linux.intel.com>,
        hpa@zytor.com, linux-kernel@vger.kernel.org, penberg@kernel.org,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
In-Reply-To: <20130503153134.GD3433@pd.tnic>
Message-ID: <alpine.DEB.2.02.1305030952140.30317@chino.kir.corp.google.com>
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com> <5182AB66.6020307@linux.intel.com> <20130502194556.GB3553@gmail.com> <20130502200703.GE16684@pd.tnic>
 <20130503142900.GA3433@pd.tnic> <5183CFAC.8020005@infradead.org> <20130503150818.GC3433@pd.tnic> <5183D357.8000204@suse.cz> <20130503153134.GD3433@pd.tnic>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 May 2013, Borislav Petkov wrote:

> * yes "" | make oldconfig - because we want to use the current config
> as a base.
> 

This will select options that you don't necessarily need but default to 
enabled when they are selected from kvm_guest.config, so it will actually 
include much more than what's needed for a kvm guest.
