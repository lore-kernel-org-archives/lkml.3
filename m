Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbaLAQWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 11:22:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaLAQW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 11:22:29 -0500
Message-ID: <547C95B8.7020300@redhat.com>
Date: Mon, 01 Dec 2014 17:22:16 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Nadav Amit <namit@cs.technion.ac.il>
Subject: Re: [PATCH 0/4] KVM: x86: APIC fixes
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 27/11/2014 20:03, Radim Krčmář wrote:
> The interesting one is [3/4], which improves upon a previous CVE fix;
> we also handle logical destination wrapping in it, so [2/4] does the
> same for physical;  and to make it nicer, [1/4] removes a condition.
> [4/4] makes our fast path return true when the message was handled.
> 
> Radim Krčmář (4):
>   KVM: x86: deliver phys lowest-prio
>   KVM: x86: fix APIC physical destination wrapping
>   KVM: x86: allow 256 logical x2APICs again
>   KVM: x86: don't retry hopeless APIC delivery
> 
>  arch/x86/kvm/lapic.c | 20 +++++++++++---------
>  arch/x86/kvm/lapic.h |  2 --
>  2 files changed, 11 insertions(+), 11 deletions(-)
> 

So the order should be 1/2/5/3/4, right?

Paolo
