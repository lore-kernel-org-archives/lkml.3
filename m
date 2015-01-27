Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760092AbbA0Vj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:39:57 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:54661 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759559AbbA0Vj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:39:56 -0500
Message-ID: <54C805A6.1030603@redhat.com>
Date: Tue, 27 Jan 2015 22:39:50 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>, "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH v3 2/6] KVM: nVMX: Enable nested virtualize x2apic mode.
References: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
In-Reply-To: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/01/2015 11:21, Wincy Van wrote:
> +static void nested_vmx_disable_intercept_for_msr(unsigned long *msr_bitmap_l1,
> +                                              unsigned long *msr_bitmap_nested,
> +                                              u32 msr, int type)
> +{
> +       int f = sizeof(unsigned long);
> +
> +       if (!cpu_has_vmx_msr_bitmap())
> +               return;
> +

Also, make this a WARN_ON.

Paolo
