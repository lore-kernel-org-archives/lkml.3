Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbaDKRlK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:41:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45596 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbaDKRlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:41:05 -0400
Message-ID: <5348291B.7090501@zytor.com>
Date: Fri, 11 Apr 2014 10:40:43 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jet Chen <jet.chen@intel.com>,
        "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
CC: Fengguang Wu <fengguang.wu@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
References: <20140407111725.GC25152@localhost> <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com> <53444220.50009@intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com> <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost> <5345D360.5000506@linux.intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com> <53475344.5090009@linux.intel.com> <C97001BC43954D438ACB059713BA5CDF92040F0F10@USEA-EXCH7.na.uis.unisys.com> <53481976.3020209@zytor.com> <534827F5.1020004@intel.com>
In-Reply-To: <534827F5.1020004@intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:35 AM, Jet Chen wrote:
> 
> As Peter said, QEMU probably should *not* set the hypervisor bit. But based on my testing, I think KVM works properly in this case.
> 

Either way, unless there is a CPUID interface exposed in CPUID levels
0x40000000+, then relying on the hypervisor bit to do VMCALL is wrong in
the extreme.

	-hpa


