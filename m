Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaHUVEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:04:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47233 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754201AbaHUVEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:04:50 -0400
Date: Thu, 21 Aug 2014 23:03:37 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 6/7] KVM: VMX: runtime knobs for dynamic PLE window
Message-ID: <20140821210337.GB30423@potion.brq.redhat.com>
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com>
 <1408637291-18533-7-git-send-email-rkrcmar@redhat.com>
 <53F645DF.4080101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F645DF.4080101@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-22 00:47+0530, Raghavendra K T:
> Positive thing about able to change default grow/shrink value is the
> flexibility of tuning ple window to different workloads and different
> number of cpus.
> 
> But is it that a value of shrink = 1 and grow > 1 is problematic ?
> (running a undercommit workload and then overcommit workload)

Yeah, could have mentioned it in commit message, but I hope that my
previous email explained it.  (1 = don't shrink, design decision :)
