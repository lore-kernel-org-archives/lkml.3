Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761566Ab3EBTqE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:46:04 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:60682 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab3EBTqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:46:01 -0400
Date: Thu, 2 May 2013 21:45:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>, hpa@zytor.com,
        linux-kernel@vger.kernel.org, penberg@kernel.org, bp@alien8.de,
        levinsasha928@gmail.com, mtosatti@redhat.com, tglx@linutronix.de,
        bp@suse.de, fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for
 building working KVM guest kernels
Message-ID: <20130502194556.GB3553@gmail.com>
References: <20130426095140.GA15361@pd.tnic>
 <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org>
 <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com>
 <5182AB66.6020307@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5182AB66.6020307@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@linux.intel.com> wrote:

> On 05/02/2013 11:06 AM, David Rientjes wrote:
> > 
> > Hi Peter,
> > 
> > You'll also need http://marc.info/?l=linux-kernel&m=136744052328802 when 
> > Borislav signs it off as it fixes one of the dependencies.  Still waiting 
> > on how X86_IO_APIC, X86_LOCAL_APIC, and NET_CORE will be resolved.
> > 
> 
> Hm.

Boris, mind posting a working version?

Thanks,

	Ingo
