Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbbA1UYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:24:45 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:55824 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605AbbA1UYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:24:41 -0500
Message-ID: <54C88ACF.9000401@redhat.com>
Date: Wed, 28 Jan 2015 08:07:59 +0100
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
Subject: Re: [PATCH v3 6/6] KVM: nVMX: Enable nested posted interrupt processing.
References: <CACzj_yWZSJkfn0JAJr9w6hLWtMbr3PpHQVxH_GkwmY8g3x1x8w@mail.gmail.com> <54C80955.4070305@redhat.com> <CACzj_yUn8yMY1iW2Umd_nYX29jw1vyuPd=m+jfx55ZwXXUPTBw@mail.gmail.com>
In-Reply-To: <CACzj_yUn8yMY1iW2Umd_nYX29jw1vyuPd=m+jfx55ZwXXUPTBw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/01/2015 06:54, Wincy Van wrote:
> Why? L1 may config these features seperately, we should check them one by one.
> e.g.  L1 may enable posted interrupt processing and virtual interrupt
> delivery, but leaving virtualize x2apic mode disabled, then
> nested_cpu_has_virt_x2apic_mode will return false.

You're right, I confused && with ||.

*blush*.

Paolo
