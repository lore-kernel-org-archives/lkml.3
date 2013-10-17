Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3JQOzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 10:55:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757133Ab3JQOzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 10:55:35 -0400
Date: Thu, 17 Oct 2013 17:55:22 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: linux-next: manual merge of the kvm-arm tree
Message-ID: <20131017145522.GH30802@redhat.com>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-3-git-send-email-treding@nvidia.com>
 <525EE1BC.3050605@arm.com>
 <CAMJs5B85FwnXN3YE5-KagSjYDH0aSeVYgcwvSXy8=LGfw=STaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMJs5B85FwnXN3YE5-KagSjYDH0aSeVYgcwvSXy8=LGfw=STaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 16, 2013 at 12:02:08PM -0700, Christoffer Dall wrote:
> On 16 October 2013 11:58, Marc Zyngier <marc.zyngier@arm.com> wrote:
> > On 16/10/13 19:51, Thierry Reding wrote:
> >> Today's linux-next merge of the kvm-arm tree got conflicts in
> >>
> >>       arch/arm/kvm/reset.c
> >>
> >> caused by commits e8c2d99 (KVM: ARM: Add support for Cortex-A7) and ac570e0
> >> (ARM: kvm: rename cpu_reset to avoid name clash).
> >>
> >> I've fixed them up (see below). Please verify that the resolution looks
> >> good.
> >
> > Looks good to me (I have the same resolution in my own tree).
> >
> Yes, fix is good.
> 
> This will stay a conflict until kvm/next and kvm/fixes merge, which
> doesn't happen before after the merge window, usually.  If that's
So in this case it happened today because part of powerpc patches where
based on commit after -rc4 and I had to merge to be able to pull them.
Christoffer can you look at queue branch of kvm.git and see that the
resolution is correct?

--
			Gleb.
