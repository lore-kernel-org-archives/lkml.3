Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbbAOLE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:04:56 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:43790 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbbAOLEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:04:53 -0500
Date: Thu, 15 Jan 2015 12:04:54 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, alex.williamson@redhat.com, agraf@suse.de,
        joel.schopp@amd.com, kim.phillips@freescale.com, paulus@samba.org,
        gleb@kernel.org, pbonzini@redhat.com, borntraeger@de.ibm.com,
        cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org,
        patches@linaro.org, will.deacon@arm.com,
        a.motakis@virtualopensystems.com, a.rigo@virtualopensystems.com,
        john.liuli@huawei.com, ming.lei@canonical.com, feng.wu@intel.com,
        b.reynal@virtualopensystems.com
Subject: Re: [PATCH v6 2/4] KVM: introduce kvm_arch_intc_initialized
Message-ID: <20150115110454.GP26222@cbox>
References: <1421170420-30617-1-git-send-email-eric.auger@linaro.org>
 <1421170420-30617-3-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421170420-30617-3-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 06:33:38PM +0100, Eric Auger wrote:
> Introduce __KVM_HAVE_ARCH_INTC_INITIALIZED define and
> associated kvm_arch_intc_initialized function. This latter
> allows to test whether the virtual interrupt controller is initialized
> and ready to accept virtual IRQ injection. On some architectures,
> the virtual interrupt controller is dynamically instantiated, justifying
> that kind of check.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
