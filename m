Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaLQKqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:46:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38506 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaLQKqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:46:35 -0500
Message-ID: <54915F00.5010304@redhat.com>
Date: Wed, 17 Dec 2014 11:46:24 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joerg Roedel <jroedel@suse.de>, "Chen, Tiejun" <tiejun.chen@intel.com>
CC: Joerg Roedel <joro@8bytes.org>, Gleb Natapov <gleb@kernel.org>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: iommu: Add cond_resched to legacy device assignment
 code
References: <1418744846-12868-1-git-send-email-joro@8bytes.org> <5490DEB1.30305@intel.com> <20141217103500.GA9373@suse.de>
In-Reply-To: <20141217103500.GA9373@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 17/12/2014 11:35, Joerg Roedel wrote:
>> > 
>> > This file is already gone after one latest commit c274e03af705,
>> > "kvm: x86: move assigned-dev.c and iommu.c to arch/x86/" is
>> > introduced, so you need to pull your tree firstly :)
> Hmm, I based the patch on kvm/master, where the file is still present.
> What is the branch to base kvm patches on these days?

kvm/master in the -rc period, kvm/next during the merge window and for
the next release.  But it's not a problem, I can sort it out.

Paolo
