Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaFFKkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 06:40:05 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:10013 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750802AbaFFKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 06:40:04 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>,
        "eric.auger\@st.com" <eric.auger@st.com>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm\@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "kvm\@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches\@linaro.org" <patches@linaro.org>,
        "christophe.barnichon\@st.com" <christophe.barnichon@st.com>
Subject: Re: [PATCH v3] ARM: KVM: Unmap IPA on memslot delete/move
In-Reply-To: <20140606091603.GA22341@lvm> (Christoffer Dall's message of "Fri,
	6 Jun 2014 10:16:03 +0100")
Organization: ARM Ltd
References: <1402045823-26912-1-git-send-email-eric.auger@linaro.org>
	<20140606091603.GA22341@lvm>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 06 Jun 2014 11:39:50 +0100
Message-ID: <87fvjiiao9.fsf@approximate.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06 2014 at 10:16:03 am BST, Christoffer Dall <christoffer.dall@linaro.org> wrote:
> On Fri, Jun 06, 2014 at 11:10:23AM +0200, Eric Auger wrote:
>> Currently when a KVM region is deleted or moved after
>> KVM_SET_USER_MEMORY_REGION ioctl, the corresponding
>> intermediate physical memory is not unmapped.
>> 
>> This patch corrects this and unmaps the region's IPA range
>> in kvm_arch_commit_memory_region using unmap_stage2_range.
>> 
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>
> I think I already acked it in the last version, if Marc is ok with it, I
> can queue it for next.

Yes, I'm quite happy for this to go in.

Acked-by: Marc Zyngier <marc.zyngier@arm.com>

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
