Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaKXRFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 12:05:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842AbaKXRFd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 12:05:33 -0500
Message-ID: <54736555.70105@redhat.com>
Date: Mon, 24 Nov 2014 18:05:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Auger <eric.auger@linaro.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
CC: rkrcmar@redhat.com
Subject: Re: [PATCH] kvm: x86: move ioapic.c and irq_comm.c back to arch/x86/
References: <1416490931-21724-1-git-send-email-pbonzini@redhat.com> <5473402E.80905@linaro.org>
In-Reply-To: <5473402E.80905@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/11/2014 15:26, Eric Auger wrote:
>> > +#ifdef __KVM_HAVE_IOAPIC
>> > +void kvm_vcpu_request_scan_ioapic(struct kvm *kvm);
>> > +#else
>> > +static inline void kvm_vcpu_request-scan_ioapic(struct kvm *kvm)
> Hi Paolo,
> 
> you have a typo above: "-" instead of "_".

Indeed, thanks.  The fixed version is already on kernel.org.

Paolo
