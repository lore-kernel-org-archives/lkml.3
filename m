Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaLQKfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:35:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43195 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159AbaLQKfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:35:05 -0500
Date: Wed, 17 Dec 2014 11:35:00 +0100
From: Joerg Roedel <jroedel@suse.de>
To: "Chen, Tiejun" <tiejun.chen@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: iommu: Add cond_resched to legacy device assignment
 code
Message-ID: <20141217103500.GA9373@suse.de>
References: <1418744846-12868-1-git-send-email-joro@8bytes.org>
 <5490DEB1.30305@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5490DEB1.30305@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2014 at 09:38:57AM +0800, Chen, Tiejun wrote:
> On 2014/12/16 23:47, Joerg Roedel wrote:
> >diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> >index c1e6ae9..ac427e8 100644
> >--- a/virt/kvm/iommu.c
> >+++ b/virt/kvm/iommu.c
> 
> This file is already gone after one latest commit c274e03af705,
> "kvm: x86: move assigned-dev.c and iommu.c to arch/x86/" is
> introduced, so you need to pull your tree firstly :)

Hmm, I based the patch on kvm/master, where the file is still present.
What is the branch to base kvm patches on these days?


	Joerg

