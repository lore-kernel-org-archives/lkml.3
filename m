Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaGDIE3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 04:04:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:62867 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaGDIE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 04:04:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,599,1400050800"; 
   d="scan'208";a="538725280"
Date: Fri, 4 Jul 2014 15:59:00 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Bandan Das <bsd@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1
 since race
Message-ID: <20140704075900.GA7447@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <53B3CA6A.4050902@siemens.com>
 <jpgy4wb9g5t.fsf@redhat.com>
 <20140703065955.GA4236@kernel>
 <jpgk37u8iae.fsf@redhat.com>
 <20140704025250.GA2849@kernel>
 <53B63EF2.6000800@siemens.com>
 <20140704060831.GA3453@kernel>
 <53B6559A.6020406@siemens.com>
 <20140704073923.GA7188@kernel>
 <53B65BDE.9090902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B65BDE.9090902@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 09:46:38AM +0200, Paolo Bonzini wrote:
>Il 04/07/2014 09:39, Wanpeng Li ha scritto:
>>PASS: test vmxon with FEATURE_CONTROL cleared
>>PASS: test vmxon without FEATURE_CONTROL lock
>>PASS: test enable VMX in FEATURE_CONTROL
>>PASS: test FEATURE_CONTROL lock bit
>>PASS: test vmxon
>>PASS: test vmptrld
>>PASS: test vmclear
>>PASS: test vmptrst
>>PASS: test vmxoff
>
>You are not running the latest versions of the tests.
>

The last commit in my tree is 

commit daeec9795d3e6d4e9636588b6cb5fcd6e00d6d46
Author: Bandan Das <bsd@redhat.com>
Date:   Mon Jun 9 17:04:54 2014 -0400

    VMX: Updated test_vmclear and test_vmptrld


>Paolo
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
