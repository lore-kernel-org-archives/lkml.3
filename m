Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050AbaGQLH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 07:07:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:17037 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003AbaGQLH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 07:07:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,677,1400050800"; 
   d="scan'208";a="544724425"
Date: Thu, 17 Jul 2014 19:08:26 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, "Hu, Robert" <robert.hu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] KVM: nVMX: Fix virtual interrupt delivery injection
Message-ID: <20140717110826.GA9872@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com>
 <53C78F67.1060802@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB31D4A@SHSMSX104.ccr.corp.intel.com>
 <20140717091148.GA7744@kernel>
 <53C7A8EE.4040605@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C7A8EE.4040605@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 12:43:58PM +0200, Paolo Bonzini wrote:
>Il 17/07/2014 11:11, Wanpeng Li ha scritto:
>>>>>> What hypervisor did you test with? nested_exit_on_intr(vcpu) will
>>>>
>>>>Jailhouse will clear External-interrupt exiting bit. Am I right? Jan.
>>>>
>>>>>> return true for both Xen and KVM (nested_exit_on_intr is not the same
>>>>>> thing as ACK_INTR_ON_EXIT).
>>>>
>>>>I guess he want to say External-interrupt exiting bit not ACK_INTR_ON_EXIT.
>>>>
>>Ah yes, a typo here.
>
>Ok, please repost this patch together with your version of patch 2.

Just send out the version two of 1/3 and 2/3. 

>
>Leave aside patch 3 for now, as I think the original use-after-free
>patch was wrong.

Any proposal is appreciated. ;-)

Regards,
Wanpeng Li 

>
>Paolo
