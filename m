Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295AbbAKMja (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:39:30 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:49575 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246AbbAKMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:39:26 -0500
Date: Sun, 11 Jan 2015 13:39:54 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v3 2/2] KVM: arm/arm64: vgic: add init entry to VGIC KVM
 device
Message-ID: <20150111123954.GW21092@cbox>
References: <1418665413-31521-1-git-send-email-eric.auger@linaro.org>
 <1418665413-31521-3-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418665413-31521-3-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 06:43:33PM +0100, Eric Auger wrote:
> Since the advent of VGIC dynamic initialization, this latter is
> initialized quite late on the first vcpu run or "on-demand", when
> injecting an IRQ or when the guest sets its registers.
> 
> This initialization could be initiated explicitly much earlier
> by the users-space, as soon as it has provided the requested
> dimensioning parameters.
> 
> This patch adds a new entry to the VGIC KVM device that allows
> the user to manually request the VGIC init:
> - a new KVM_DEV_ARM_VGIC_GRP_CTRL group is introduced.
> - Its first attribute is KVM_DEV_ARM_VGIC_CTRL_INIT
> 
> The rationale behind introducing a group is to be able to add other
> controls later on, if needed.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
This looks good to me:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
