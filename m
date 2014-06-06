Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaFFJQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:16:10 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:33895 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaFFJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:16:07 -0400
Date: Fri, 6 Jun 2014 11:16:03 +0200
From: Christoffer Dall <christoffer.dall@linaro.org>
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, marc.zyngier@arm.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org,
        christophe.barnichon@st.com
Subject: Re: [PATCH v3] ARM: KVM: Unmap IPA on memslot delete/move
Message-ID: <20140606091603.GA22341@lvm>
References: <1402045823-26912-1-git-send-email-eric.auger@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402045823-26912-1-git-send-email-eric.auger@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 11:10:23AM +0200, Eric Auger wrote:
> Currently when a KVM region is deleted or moved after
> KVM_SET_USER_MEMORY_REGION ioctl, the corresponding
> intermediate physical memory is not unmapped.
> 
> This patch corrects this and unmaps the region's IPA range
> in kvm_arch_commit_memory_region using unmap_stage2_range.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>

I think I already acked it in the last version, if Marc is ok with it, I
can queue it for next.

-Christoffer
