Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaKXJsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:48:21 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:56325 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbaKXJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:48:19 -0500
Date: Mon, 24 Nov 2014 10:48:49 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, joel.schopp@amd.com,
        kim.phillips@freescale.com, paulus@samba.org, gleb@kernel.org,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org, patches@linaro.org,
        will.deacon@arm.com, a.motakis@virtualopensystems.com,
        a.rigo@virtualopensystems.com, john.liuli@huawei.com,
        ming.lei@canonical.com, feng.wu@intel.com
Subject: Re: [PATCH v4 1/3] KVM: arm/arm64: unset CONFIG_HAVE_KVM_IRQCHIP
Message-ID: <20141124094849.GI3401@cbox>
References: <1416765420-12057-1-git-send-email-eric.auger@linaro.org>
 <1416765420-12057-2-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416765420-12057-2-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 06:56:58PM +0100, Eric Auger wrote:
> CONFIG_HAVE_KVM_IRQCHIP is needed to support IRQ routing (along
> with irq_comm.c and irqchip.c usage). This is not the case for
> arm/arm64 currently.
> 
> This patch unsets the flag for both arm and arm64.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>

I don't fully understand why we used to have these and we don't need
them anymore.  Was it just a stupid bug in the past?

Anyhow, looks reasonable:

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

-Christoffer
