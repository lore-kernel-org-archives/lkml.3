Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbbAPJgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 04:36:10 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60000 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752591AbbAPJgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 04:36:04 -0500
Message-ID: <54B8DB80.50202@arm.com>
Date: Fri, 16 Jan 2015 09:36:00 +0000
From: =?windows-1252?Q?Andr=E9_Przywara?= <andre.przywara@arm.com>
Organization: ARM Ltd.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Eric Auger <eric.auger@linaro.org>, eric.auger@st.com,
        christoffer.dall@linaro.org, marc.zyngier@arm.com,
        andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        alex.williamson@redhat.com, agraf@suse.de, gleb@kernel.org,
        pbonzini@redhat.com, borntraeger@de.ibm.com, cornelia.huck@de.ibm.com
CC: will.deacon@arm.com, linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v7 3/4] KVM: arm/arm64: implement kvm_arch_intc_initialized
References: <1421333267-15287-1-git-send-email-eric.auger@linaro.org> <1421333267-15287-4-git-send-email-eric.auger@linaro.org>
In-Reply-To: <1421333267-15287-4-git-send-email-eric.auger@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 02:47 PM, Eric Auger wrote:
> On arm/arm64 the VGIC is dynamically instantiated and it is useful
> to expose its state, especially for irqfd setup.
> 
> This patch defines __KVM_HAVE_ARCH_INTC_INITIALIZED and
> implements kvm_arch_intc_initialized.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

Reviewed-by: Andre Przywara <andre.przywara@arm.com>

Cheers,
Andre.

