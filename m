Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762810AbbA2CpF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:45:05 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58075 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762752AbbA2CpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:45:01 -0500
MIME-Version: 1.0
In-Reply-To: <54C89044.2090104@redhat.com>
References: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
 <54C804FD.6060108@redhat.com> <CACzj_yUdLy5QjpNTqesWbvR6ytTixszJNNOZvH=bw-SOhrjapw@mail.gmail.com>
 <54C89044.2090104@redhat.com>
From: Wincy Van <fanwenyi0529@gmail.com>
Date: Wed, 28 Jan 2015 18:19:03 +0800
Message-ID: <CACzj_yXN5EAHzy_RfYbjgD2a8e4trJ-j78R4vU3Q6+6KbAm=Vw@mail.gmail.com>
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

On Wed, Jan 28, 2015 at 3:31 PM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>>> >
>>> > No need for this function and nested_cpu_has_virt_x2apic_mode.  Just
>>> > inline them in their caller(s).  Same for other cases throughout the series.
>>> >
>> Do you mean that we should also inline the same functions in the other
>> patches of this patch set?
>> I think these functions will keep the code tidy, just like the
>> functions as nested_cpu_has_preemption_timer, nested_cpu_has_ept, etc.
>
> Most of the functions are just used once.  If you want to keep them,
> please place them all close to the existing ones.
>

Yep, I will inline the functions like nested_vmx_check_virt_x2apic and keep
the nested_cpu_has series.


Thanks,
Wincy
