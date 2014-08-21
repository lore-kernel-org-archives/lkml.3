Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbaHUQuU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:50:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbaHUQuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:50:18 -0400
Date: Thu, 21 Aug 2014 18:50:03 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 0/7] Dynamic Pause Loop Exiting window.
Message-ID: <20140821165002.GG20453@potion.brq.redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <53F61EAC.2000004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F61EAC.2000004@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 18:30+0200, Paolo Bonzini:
> Il 21/08/2014 18:08, Radim Krčmář ha scritto:
> I'm not sure of the usefulness of patch 6, so I'm going to drop it.
> I'll keep it in my local junkyard branch in case it's going to be useful
> in some scenario I didn't think of.

I've been using it to benchmark different values, because it is more
convenient than reloading the module after shutting down guests.
(And easier to sell than writing to kernel memory.)

I don't think the additional code is worth it though.

> Patch 7 can be easily rebased, so no need to repost (and I might even
> squash it into patch 3, what do you think?).

Yeah, the core is already a huge patch, so it does look weird without
squashing.  (No-one wants to rebase to that point anyway.)

Thanks.
