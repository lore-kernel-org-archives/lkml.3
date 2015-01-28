Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbbA1U6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:58:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755737AbbA1U6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:58:30 -0500
Message-ID: <54C8B7F8.6070009@redhat.com>
Date: Wed, 28 Jan 2015 11:20:40 +0100
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
References: <CACzj_yXLgAKaRzXx4Y=ZQN=QXK8EnX4fvcSTJmKSXSywN2Kb8Q@mail.gmail.com> <54C804FD.6060108@redhat.com> <CACzj_yUdLy5QjpNTqesWbvR6ytTixszJNNOZvH=bw-SOhrjapw@mail.gmail.com> <54C89044.2090104@redhat.com> <CACzj_yXN5EAHzy_RfYbjgD2a8e4trJ-j78R4vU3Q6+6KbAm=Vw@mail.gmail.com>
In-Reply-To: <CACzj_yXN5EAHzy_RfYbjgD2a8e4trJ-j78R4vU3Q6+6KbAm=Vw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 28/01/2015 11:19, Wincy Van wrote:
> > Most of the functions are just used once.  If you want to keep them,
> > please place them all close to the existing ones.
>
> Yep, I will inline the functions like nested_vmx_check_virt_x2apic and keep
> the nested_cpu_has series.

Okay, thanks!

Paolo
