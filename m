Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbbAKMjn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:39:43 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:36518 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbbAKMjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:39:33 -0500
Date: Sun, 11 Jan 2015 13:40:01 +0100
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com, andre.przywara@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v3 1/2] KVM: arm/arm64: vgic: vgic_init returns -ENODEV
 when no online vcpu
Message-ID: <20150111124001.GX21092@cbox>
References: <1418665413-31521-1-git-send-email-eric.auger@linaro.org>
 <1418665413-31521-2-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418665413-31521-2-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 06:43:32PM +0100, Eric Auger wrote:
> To be more explicit on vgic initialization failure, -ENODEV is
> returned by vgic_init when no online vcpus can be found at init.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
