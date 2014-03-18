Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbaCRPVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:21:43 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:53139 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754926AbaCRPVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:21:41 -0400
Message-ID: <53286480.7030807@redhat.com>
Date: Tue, 18 Mar 2014 16:21:36 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org
CC: gleb@kernel.org, mtosatti@redhat.com, kvm@vger.kernel.org
Subject: Re: [PATCH 4/4] KVM: ioapic: reinject pending interrupts on KVM_SET_IRQCHIP
References: <1395154495-22807-1-git-send-email-pbonzini@redhat.com> <1395154495-22807-5-git-send-email-pbonzini@redhat.com> <532861EF.8050001@siemens.com>
In-Reply-To: <532861EF.8050001@siemens.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/03/2014 16:10, Jan Kiszka ha scritto:
>> > +void kvm_ioapic_inject_all(struct kvm_ioapic *ioapic, unsigned long irr)
> static? (Didn't the compiler bark at you?)

I re-checked and it didn't indeed.  Fixed this locally.

Paolo

