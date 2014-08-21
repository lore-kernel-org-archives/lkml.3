Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbaHULjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 07:39:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52545 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530AbaHULjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 07:39:06 -0400
Date: Thu, 21 Aug 2014 13:38:54 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 3/6] KVM: VMX: make PLE window per-VCPU
Message-ID: <20140821113853.GB20546@potion.brq.redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
 <1408567997-21222-4-git-send-email-rkrcmar@redhat.com>
 <53F5AD14.9050405@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5AD14.9050405@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 10:25+0200, Paolo Bonzini:
> Il 20/08/2014 22:53, Radim Krčmář ha scritto:
> > +	if (ple_gap)
> > +		vmcs_write32(PLE_WINDOW, vmx->ple_window);
> 
> Maybe we can add a ple_window_dirty field?  It can be tested instead of
> ple_gap to avoid the vmwrite in the common case?

Sure, v3!
