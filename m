Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaKZRPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 12:15:05 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:45964 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKZRPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:15:03 -0500
MIME-Version: 1.0
In-Reply-To: <20141126160720.GD3245@hawk.usersys.redhat.com>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
 <1416931805-23223-5-git-send-email-alex.bennee@linaro.org> <20141126160720.GD3245@hawk.usersys.redhat.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Wed, 26 Nov 2014 17:14:40 +0000
Message-ID: <CAFEAcA-xV80Z3j52H5yh2e+JxOo5=inZNcM54HkOa2U2rBvKhQ@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: arm64: guest debug, add SW break point support
To: Andrew Jones <drjones@redhat.com>
Cc: =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        kvm-devel <kvm@vger.kernel.org>,
        arm-mail-list <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Gleb Natapov <gleb@kernel.org>,
        "J. Kiszka" <jan.kiszka@siemens.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>,
        David Hildenbrand <dahi@linux.vnet.ibm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bharat Bhushan <r65777@freescale.com>,
        Paolo Bonzini <pbonzini@redhat.com>, bp@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2014 at 16:07, Andrew Jones <drjones@redhat.com> wrote:
> There appears to be a typo in the ARM ARM. Subsection "Software
> Breakpoint Instruction exception" of D1.10.4 says BRK (ESR_EL2_EC_BRK64)
> is 0x39, but the table above that has it correctly as 0x3c.

Thanks for pointing out this typo -- I've reported it to the
appropriate documentation people.

-- PMM
