Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaHUMmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 08:42:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbaHUMmg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 08:42:36 -0400
Date: Thu, 21 Aug 2014 14:42:24 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v2 4/6] KVM: VMX: dynamise PLE window
Message-ID: <20140821124223.GD20453@potion.brq.redhat.com>
References: <1408567997-21222-1-git-send-email-rkrcmar@redhat.com>
 <1408567997-21222-5-git-send-email-rkrcmar@redhat.com>
 <53F5AD3E.3050800@redhat.com>
 <20140821115405.GD20546@potion.brq.redhat.com>
 <53F5E623.5090906@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F5E623.5090906@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-21 14:29+0200, Paolo Bonzini:
> Il 21/08/2014 13:54, Radim Krčmář ha scritto:
> > Guity as charged.
> > Using 0/1 or true/false in this context directly would be pretty bad ...
> > Is enum fine? (SHIRINK_PLE_WINDOW, GROW_PLE_WINDOW?)
> 
> I prefer good old Ctrl-C Ctrl-V (adjusted for your favorite editor). :)

I, I should be able to do it, but nightmares are going to last a while.

(And to lower chances of v4: are tracepoint macros, like for kvm_apic,
 frowned upon now?)
