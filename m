Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaHTPeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:34:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316AbaHTPeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:34:22 -0400
Message-ID: <53F4BFF3.3060606@redhat.com>
Date: Wed, 20 Aug 2014 17:34:11 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi <hui-zhi.zhao@hp.com>
Subject: Re: [PATCH 9/9] KVM: VMX: automatic PLE window maximum
References: <1408480536-8240-1-git-send-email-rkrcmar@redhat.com> <1408480536-8240-10-git-send-email-rkrcmar@redhat.com> <53F44B40.6060806@redhat.com> <20140820124112.GC28873@potion.brq.redhat.com> <53F49F80.1090408@redhat.com> <20140820153115.GA20453@potion.brq.redhat.com>
In-Reply-To: <20140820153115.GA20453@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2014 17:31, Radim Krčmář ha scritto:
> Btw. without extra code, we are still going to overflow on races when
> changing PW_grow, should they be covered as well?

You mean because there is no spinlock or similar protecting the changes?
 I guess you could use a seqlock.

Paolo
