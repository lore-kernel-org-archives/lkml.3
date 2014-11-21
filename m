Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbaKUBJl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:09:41 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40778 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756702AbaKUBJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:09:40 -0500
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: KVM causes #GP on XRSTORS
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20141121001033.GA10834@kernel>
Date: Fri, 21 Nov 2014 03:09:36 +0200
Cc: Paolo Bonzini <pbonzini@redhat.com>, fenghua.yu@intel.com,
        kvm list <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AC569D54-4EA9-4090-AE7E-816576BCF2B8@gmail.com>
References: <AA52FB0B-FB19-4DC0-964B-2984040B15A6@gmail.com> <20141121001033.GA10834@kernel>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Nov 21, 2014, at 02:10, Wanpeng Li <wanpeng.li@linux.intel.com> wrote:
> 
> Hi Nadav,
> On Thu, Nov 20, 2014 at 06:34:04PM +0200, Nadav Amit wrote:
>> Fenghua,
>> 
>> I got KVM (v3.17) crashing on a machine that supports XRSTORS - It appears to get a #GP when it is trying to load the guest FPU.
>> One reason for the #GP is that XCOMP_BV[63] is zeroed on the guest_fpu, but I am not sure it is the only problem.
>> Was KVM ever tested with XRSTORS?
> 
> Current kvm and qemu use standard format and xsaves/xrstors should use
> compact format, in addition, vmx is still not enabled for xsaves/xrstors 
> in kvm.

Sorry, but I don’t quite understand. Should KVM work on a machine that supports xsaves/xrstors?
I am not referring to whether KVM exposes the capability to the guest, but to whether KVM should work at all.

Thanks,
Nadav


