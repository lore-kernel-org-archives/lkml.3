Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbaHTM1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:27:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11486 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbaHTM1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:27:03 -0400
Date: Wed, 20 Aug 2014 14:26:54 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 3/9] KVM: VMX: make PLE window per-vcpu
Message-ID: <20140820122654.GB28873@potion.brq.redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
 <1408480536-8240-4-git-send-email-rkrcmar@redhat.com>
 <53F44AAD.5020203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F44AAD.5020203@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 09:13+0200, Paolo Bonzini:
> Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> >  enum segment_cache_field {
> > @@ -4403,6 +4406,7 @@ static int vmx_vcpu_setup(struct vcpu_vmx *vmx)
> >  	if (ple_gap) {
> >  		vmcs_write32(PLE_GAP, ple_gap);
> >  		vmcs_write32(PLE_WINDOW, ple_window);
> 
> Is this necessary?

V2, thanks.
