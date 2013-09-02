Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891Ab3IBP64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 11:58:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287Ab3IBP6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 11:58:54 -0400
Message-ID: <5224B5B1.30401@redhat.com>
Date: Mon, 02 Sep 2013 17:58:41 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glin@suse.de,
        agraf@suse.de, brogers@suse.de, afaerber@suse.de, lnussel@suse.de,
        edk2-devel@lists.sf.net, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com> <20130901091744.GF22899@redhat.com> <52245D81.7060402@linux.vnet.ibm.com> <20130902094907.GP22899@redhat.com> <522462D6.8090806@linux.vnet.ibm.com> <20130902101114.GR22899@redhat.com>
In-Reply-To: <20130902101114.GR22899@redhat.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/09/2013 12:11, Gleb Natapov ha scritto:
>> > 
>> > Got it, thanks for your explanation.
>> > 
>> > BTW, if you and Paolo are busy on other things, i am happy to fix these issues. :)
> I am busy with reviews mostly :). If you are not to busy with lockless
> write protection then fine with me. Lest wait for Paolo's input on
> proposed API though.

No problem, I'm happy to do this kind of exercise.  I like the API you
proposed.  I can do this change on top of the API change.  However,
since this bug is "in the wild" it may be applicable to stable@ as well.
 If you agree, I will also post v2 of this patch for stable kernels as
soon as we agree on the desired faulting behavior.

Paolo
