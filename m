Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbbA1V3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:29:47 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:62914 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934396AbbA1Urw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:47:52 -0500
Message-ID: <54C89044.2090104@redhat.com>
Date: Wed, 28 Jan 2015 08:31:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Wincy Van <fanwenyi0529@gmail.com>
CC: "gleb@kernel.org" <gleb@kernel.org>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@web.de>
Subject: Re: [PATCH v3 2/6] KVM: nVMX: Enable nested virtualize x2apic mode.
References: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com> <54C804FD.6060108@redhat.com> <CACzj_yUdLy5QjpNTqesWbvR6ytTixszJNNOZvH=bw-SOhrjapw@mail.gmail.com>
In-Reply-To: <CACzj_yUdLy5QjpNTqesWbvR6ytTixszJNNOZvH=bw-SOhrjapw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/01/2015 07:19, Wincy Van wrote:
>> >
>> > No need for this function and nested_cpu_has_virt_x2apic_mode.  Just
>> > inline them in their caller(s).  Same for other cases throughout the series.
>> >
> Do you mean that we should also inline the same functions in the other
> patches of this patch set?
> I think these functions will keep the code tidy, just like the
> functions as nested_cpu_has_preemption_timer, nested_cpu_has_ept, etc.

Most of the functions are just used once.  If you want to keep them,
please place them all close to the existing ones.

Paolo
