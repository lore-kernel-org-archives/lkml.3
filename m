Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbaIRPNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 11:13:25 -0400
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:34247 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870AbaIRPNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 11:13:24 -0400
From: Marc Zyngier <marc.zyngier@arm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoffer Dall <cdall@cs.columbia.edu>,
        "linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree with the kvm tree
In-Reply-To: <20140918135226.0526f91f@canb.auug.org.au> (Stephen Rothwell's
	message of "Thu, 18 Sep 2014 04:52:26 +0100")
Organization: ARM Ltd
References: <20140918135226.0526f91f@canb.auug.org.au>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Thu, 18 Sep 2014 16:13:09 +0100
Message-ID: <86zjdxuflm.fsf@arm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18 2014 at 04:52:26 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Today's linux-next merge of the kvm-arm tree got a conflict in
> virt/kvm/arm/vgic.c between commit c06a841bf363 ("KVM: ARM: vgic:
> register kvm_device_ops dynamically") from the kvm tree and commit
> de56fb1923ca ("KVM: vgic: declare probe function pointer as const")
> from the kvm-arm tree.
>
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Looks good, thanks Stephen.

	M.
-- 
Jazz is not dead. It just smells funny.
