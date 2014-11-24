Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297AbaKXKAy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:00:54 -0500
Received: from mail-la0-f49.google.com ([209.85.215.49]:36880 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaKXKAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:00:52 -0500
Date: Mon, 24 Nov 2014 11:01:23 +0100
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
Subject: Re: [PATCH v4 3/3] KVM: arm64: add irqfd support
Message-ID: <20141124100123.GK3401@cbox>
References: <1416765420-12057-1-git-send-email-eric.auger@linaro.org>
 <1416765420-12057-4-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416765420-12057-4-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 06:57:00PM +0100, Eric Auger wrote:
> From: Joel Schopp <joel.schopp@amd.com>
> 
> This patch enables irqfd for arm64.
> 
> Signed-off-by: Joel Schopp <joel.schopp@amd.com>
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> 
> [Eric Auger]
> - originates from Joel's [RFC PATCH] arm64: KVM: add irqfd support
>   http://www.spinics.net/lists/kvm-arm/msg10798.html
> - isolates modifications really related to irqfd
> ---

This looks overly complicated to preserve authorship, if Joel is ok with
it, I suggest sqaushing this into the previous patch.

-Christoffer
