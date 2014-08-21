Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbaHUVMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 17:12:53 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:47435 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123AbaHUVMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 17:12:52 -0400
Message-ID: <53F660CE.7020405@redhat.com>
Date: Thu, 21 Aug 2014 23:12:46 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>, Vinod Chegu <chegu_vinod@hp.com>,
        Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 1/7] KVM: add kvm_arch_sched_in
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-2-git-send-email-rkrcmar@redhat.com> <53F63F36.9080704@linux.vnet.ibm.com> <20140821203110.GA30423@potion.brq.redhat.com>
In-Reply-To: <20140821203110.GA30423@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/08/2014 22:31, Radim Krčmář ha scritto:
>> > No surprise that ia64 doesn't show here :).
> Oh, totally forgot about its predicted comeback ...
> Paolo, do you want to fixup this?  (It removes double newline.)

Bah, me too.  I'll get to killing ia64 one of these days.

Paolo
