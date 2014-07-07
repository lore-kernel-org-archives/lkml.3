Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaGGItj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 04:49:39 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63830 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaGGItg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 04:49:36 -0400
Date: Mon, 7 Jul 2014 01:49:48 -0700
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: KVM: allow export and import of generic timer regs
Message-ID: <20140707084948.GE20451@cbox>
References: <1404485654-32674-1-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1404485654-32674-1-git-send-email-alex.bennee@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 03:54:14PM +0100, Alex Bennée wrote:
> For correct guest suspend/resume behaviour we need to ensure we include
> the generic timer registers for 64 bit guests. As CONFIG_KVM_ARM_TIMER is
> always set for arm64 we don't need to worry about null implementations.
> However I have re-jigged the kvm_arm_timer_set/get_reg declarations to
> be in the common include/kvm/arm_arch_timer.h headers.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
