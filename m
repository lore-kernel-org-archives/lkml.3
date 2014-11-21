Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbaKUAb1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 19:31:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:31127 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756982AbaKUAbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 19:31:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,426,1413270000"; 
   d="scan'208";a="611506754"
Date: Fri, 21 Nov 2014 08:10:33 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Nadav Amit <nadav.amit@gmail.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, fenghua.yu@intel.com,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: KVM causes #GP on XRSTORS
Message-ID: <20141121001033.GA10834@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <AA52FB0B-FB19-4DC0-964B-2984040B15A6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AA52FB0B-FB19-4DC0-964B-2984040B15A6@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nadav,
On Thu, Nov 20, 2014 at 06:34:04PM +0200, Nadav Amit wrote:
>Fenghua,
>
>I got KVM (v3.17) crashing on a machine that supports XRSTORS - It appears to get a #GP when it is trying to load the guest FPU.
>One reason for the #GP is that XCOMP_BV[63] is zeroed on the guest_fpu, but I am not sure it is the only problem.
>Was KVM ever tested with XRSTORS?

Current kvm and qemu use standard format and xsaves/xrstors should use
compact format, in addition, vmx is still not enabled for xsaves/xrstors 
in kvm.

Regards,
Wanpeng Li 

>
>Thanks,
>Nadav
>
>--
>To unsubscribe from this list: send the line "unsubscribe kvm" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
