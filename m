Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaHVImv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:42:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:18848 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbaHVImt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:42:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,378,1406617200"; 
   d="scan'208";a="562039897"
Date: Fri, 22 Aug 2014 16:44:07 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Zhang Yang <yang.z.zhang@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] KVM: nVMX: nested TPR shadow/threshold emulation
Message-ID: <20140822084407.GA6610@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1408621610-9665-1-git-send-email-wanpeng.li@linux.intel.com>
 <1408621610-9665-2-git-send-email-wanpeng.li@linux.intel.com>
 <53F5E720.9000308@redhat.com>
 <20140821233029.GA2420@kernel>
 <53F700F7.8020909@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F700F7.8020909@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:36:07AM +0200, Paolo Bonzini wrote:
>Il 22/08/2014 01:30, Wanpeng Li ha scritto:
>> Maybe I misunderstand your comments "On real hardware you could point
>> the virtual-APIC page to an invalid address."
>> http://lists.openwall.net/linux-kernel/2014/08/07/344
>> 
>
>That referred to an address that doesn't correspond to RAM.  You can use
>addresses like these in a real processor.
>
>But the manual says that "if the “use TPR shadow” VM-execution control
>is 1, VM entry ensures that the virtual-APIC address is 4-KByte aligned"
>(24.6.8 Controls For APIC Virtualization).  This is the check that is
>missing.

Ok, thanks.

Regards,
Wanpeng Li 
>
>Paolo
