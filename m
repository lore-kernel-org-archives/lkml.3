Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761207Ab3EBSHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 14:07:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:14786 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760739Ab3EBSHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 14:07:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,597,1363158000"; 
   d="scan'208";a="235989463"
Message-ID: <5182AB66.6020307@linux.intel.com>
Date: Thu, 02 May 2013 11:07:34 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        penberg@kernel.org, bp@alien8.de, levinsasha928@gmail.com,
        mtosatti@redhat.com, tglx@linutronix.de, bp@suse.de,
        fengguang.wu@intel.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86/kconfig:  Add a Kconfig shortcut for building
 working KVM guest kernels
References: <20130426095140.GA15361@pd.tnic> <tip-7e0320e733eec67e40d2b53e438d9971f079862d@git.kernel.org> <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.02.1305021104440.2493@chino.kir.corp.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2013 11:06 AM, David Rientjes wrote:
> 
> Hi Peter,
> 
> You'll also need http://marc.info/?l=linux-kernel&m=136744052328802 when 
> Borislav signs it off as it fixes one of the dependencies.  Still waiting 
> on how X86_IO_APIC, X86_LOCAL_APIC, and NET_CORE will be resolved.
> 

Hm.

Let's drop this one for right now.  I need to queue up some actual
urgent fixes...

	-hpa

