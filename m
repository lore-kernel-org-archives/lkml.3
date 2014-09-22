Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaIVV1A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:27:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbaIVV07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:26:59 -0400
Message-ID: <54209410.40203@redhat.com>
Date: Mon, 22 Sep 2014 23:26:40 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Christoffer Dall <christofferdall@christofferdall.dk>
CC: Marc Zyngier <marc.zyngier@arm.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Eric Auger <eric.auger@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the kvm-arm tree
References: <20140922140645.7c2ad9c8@canb.auug.org.au> <CAEDV+g+qVgG+=1Q7gBCPs8oAjK8rpzpoQ2cPMF0hi5Q1M3Nckw@mail.gmail.com>
In-Reply-To: <CAEDV+g+qVgG+=1Q7gBCPs8oAjK8rpzpoQ2cPMF0hi5Q1M3Nckw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 22/09/2014 21:46, Christoffer Dall ha scritto:
> 
> I've taken a stab at fixing this properly, can you have a quick look and
> let me know if you prefer this or if I should just revert the commit?
> 
> https://git.linaro.org/people/christoffer.dall/linux-kvm-arm.git/commit/3d2603609f2adaae85dd1ef9884270331ec120e3

I think you should include ioapic.h (under #ifdef __KVM_HAVE_IOAPIC as
in your patch), not irq.h.  However, I haven't compiled it. Please send
the patch for inclusion in my tree, and I'll fix the conflict when I
pull from you.

Paolo
