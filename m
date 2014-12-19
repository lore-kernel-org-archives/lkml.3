Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582AbaLSOnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:43:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298AbaLSOnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:43:05 -0500
Message-ID: <54943966.3040309@redhat.com>
Date: Fri, 19 Dec 2014 15:42:46 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, gleb@kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Question about hrtimer_restart apic_timer_fn in lapic.c
References: <549319DD.1020908@gmail.com> <54940BF0.1020104@redhat.com> <5494304F.30802@gmail.com> <54943249.3050300@redhat.com> <5494393D.3070904@gmail.com>
In-Reply-To: <5494393D.3070904@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/12/2014 15:42, nick wrote:
> Sorry Paolo,
> I am confused of where you would want me to move it as I looked around and there seems to be no real place to 
> put it.

To a new function called kvm_vcpu_set_pending_timer.

Paolo
