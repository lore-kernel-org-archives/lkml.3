Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016AbaHYOpU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932233AbaHYOpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:45:17 -0400
Message-ID: <53FB4BD0.6050908@redhat.com>
Date: Mon, 25 Aug 2014 16:44:32 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>
CC: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gleb Natapov <gleb@kernel.org>,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>,
        Vinod Chegu <chegu_vinod@hp.com>, Hui-Zhi Zhao <hui-zhi.zhao@hp.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Lisa Mitchell <lisa.mitchell@hp.com>
Subject: Re: [PATCH v3 5/7] KVM: trace kvm_ple_window grow/shrink
References: <1408637291-18533-1-git-send-email-rkrcmar@redhat.com> <1408637291-18533-6-git-send-email-rkrcmar@redhat.com> <20140825135341.GA20218@kria> <20140825143256.GB11024@potion.brq.redhat.com>
In-Reply-To: <20140825143256.GB11024@potion.brq.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 25/08/2014 16:32, Radim Krčmář ha scritto:
> Paolo, can you still fix this "just" by rebasing?

Maybe I could, but I just pushed the fix to kvm/next as a separate commit.

Paolo
