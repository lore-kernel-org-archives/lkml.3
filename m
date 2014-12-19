Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaLSOMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:12:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbaLSOMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:12:41 -0500
Message-ID: <54943249.3050300@redhat.com>
Date: Fri, 19 Dec 2014 15:12:25 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, gleb@kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Question about hrtimer_restart apic_timer_fn in lapic.c
References: <549319DD.1020908@gmail.com> <54940BF0.1020104@redhat.com> <5494304F.30802@gmail.com>
In-Reply-To: <5494304F.30802@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 19/12/2014 15:03, nick wrote:
> Paolo,
> If that is the case why don't I just move this function over if we don't need it in this file into x86.c.
> This seems to be the easiest solution from my understanding.
> Regards,

Only that line would have to be moved to x86.c.  You can send a patch
for that.

Paolo
