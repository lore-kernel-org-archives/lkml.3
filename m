Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaGGHa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 03:30:59 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:16778 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751163AbaGGHa6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 03:30:58 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>
Cc: "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: KVM: allow export and import of generic timer regs
In-Reply-To: <1404485654-32674-1-git-send-email-alex.bennee@linaro.org>
 ("Alex
	\=\?utf-8\?Q\?Benn\=C3\=A9e\=22's\?\= message of "Fri, 4 Jul 2014 15:54:14 +0100")
Organization: ARM Ltd
References: <1404485654-32674-1-git-send-email-alex.bennee@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Mon, 07 Jul 2014 08:30:41 +0100
Message-ID: <87mwclbp7i.fsf@why.wild-wind.fr.eu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04 2014 at  3:54:14 pm BST, Alex Bennée <alex.bennee@linaro.org> wrote:
> For correct guest suspend/resume behaviour we need to ensure we include
> the generic timer registers for 64 bit guests. As CONFIG_KVM_ARM_TIMER is
> always set for arm64 we don't need to worry about null implementations.
> However I have re-jigged the kvm_arm_timer_set/get_reg declarations to
> be in the common include/kvm/arm_arch_timer.h headers.
>
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

	M.
-- 
Without deviation from the norm, progress is not possible.
