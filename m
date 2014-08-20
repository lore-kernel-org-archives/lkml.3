Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbaHTMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:25:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752047AbaHTMZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:25:56 -0400
Date: Wed, 20 Aug 2014 14:25:41 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 7/9] KVM: VMX: abstract ple_window modifiers
Message-ID: <20140820122541.GA28873@potion.brq.redhat.com>
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com>
 <1408480536-8240-8-git-send-email-rkrcmar@redhat.com>
 <53F44815.9020309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53F44815.9020309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 09:02+0200, Paolo Bonzini:
> Il 19/08/2014 22:35, Radim Krčmář ha scritto:
> > They were almost identical and thus merged with a loathable macro.
> > 
> > Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> > ---
> >  This solution is hopefully more acceptable than function pointers.
> 
> I think a little amount of duplication is not a problem.

Ok, I'll drop this patch from from v2.
