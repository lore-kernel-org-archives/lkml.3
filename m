Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761263AbbA1GVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 01:21:04 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51391 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbbA1GVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 01:21:01 -0500
MIME-Version: 1.0
In-Reply-To: <54C805A6.1030603@redhat.com>
References: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
 <54C805A6.1030603@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 14:20:39 +0800
Message-ID: <CACzj_yVjtSk9NLJ4dcnAVvD-Y3HRsz9_cNiO2-3gKnf=eCA6Vw@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] KVM: nVMX: Enable nested virtualize x2apic mode.
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 28, 2015 at 5:39 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 24/01/2015 11:21, Wincy Van wrote:
>> +static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
>> +                                              unsigned long *msr_bitmap_nested,
>> +                                              u32 msr, int type)
>> +{
>> +       int f = sizeof(unsigned long);
>> +
>> +       if (!cpu_has_vmx_msr_bitmap())
>> +               return;
>> +
>
> Also, make this a WARN_ON.

WIll do.



Thanks,
Wincy


>
> Paolo
