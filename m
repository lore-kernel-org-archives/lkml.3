Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894Ab3IBQ2K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 12:28:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756122Ab3IBQ2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 12:28:07 -0400
Date: Mon, 2 Sep 2013 19:27:56 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, glin@suse.de,
        agraf@suse.de, brogers@suse.de, afaerber@suse.de, lnussel@suse.de,
        edk2-devel@lists.sf.net, stable@vger.kernel.org
Subject: Re: [PATCH] KVM: mmu: allow page tables to be in read-only slots
Message-ID: <20130902162755.GI10142@redhat.com>
References: <1377866497-3866-1-git-send-email-pbonzini@redhat.com>
 <20130901091744.GF22899@redhat.com>
 <52245D81.7060402@linux.vnet.ibm.com>
 <20130902094907.GP22899@redhat.com>
 <522462D6.8090806@linux.vnet.ibm.com>
 <20130902101114.GR22899@redhat.com>
 <5224B5B1.30401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224B5B1.30401@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 05:58:41PM +0200, Paolo Bonzini wrote:
> Il 02/09/2013 12:11, Gleb Natapov ha scritto:
> >> > 
> >> > Got it, thanks for your explanation.
> >> > 
> >> > BTW, if you and Paolo are busy on other things, i am happy to fix these issues. :)
> > I am busy with reviews mostly :). If you are not to busy with lockless
> > write protection then fine with me. Lest wait for Paolo's input on
> > proposed API though.
> 
> No problem, I'm happy to do this kind of exercise.  I like the API you
> proposed.  I can do this change on top of the API change.  However,
> since this bug is "in the wild" it may be applicable to stable@ as well.
>  If you agree, I will also post v2 of this patch for stable kernels as
> soon as we agree on the desired faulting behavior.
> 
I am OK with having minimal patch for backporting to stable and doing
API changes + fixes for other call sites on top.

--
			Gleb.
