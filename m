Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525AbaIHPag (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:30:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32820 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaIHP27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:28:59 -0400
Message-ID: <540DCB35.7080405@canonical.com>
Date: Mon, 08 Sep 2014 10:28:53 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] KVM: x86: fix kvmclock breakage from timers branch merge
References: <1409835487-14371-1-git-send-email-pbonzini@redhat.com> <alpine.DEB.2.10.1409042230020.3333@nanos> <5408D815.9090105@redhat.com> <alpine.DEB.2.10.1409050000570.3333@nanos> <5409E755.4040905@redhat.com> <alpine.DEB.2.10.1409052031140.5472@nanos> <540A1F22.7020107@redhat.com> <alpine.DEB.2.10.1409052239330.5472@nanos> <540A2474.7060306@redhat.com>
In-Reply-To: <540A2474.7060306@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 04:00 PM, Paolo Bonzini wrote:
> Il 05/09/2014 22:41, Thomas Gleixner ha scritto:
>> No, it needs to be above update_vsyscall(). Here is the patch again
>> which I sent before. [https://lkml.org/lkml/2014/9/5/395]
> 
> Ah, I missed it after your signature.  Thanks, I'll test yours then next
> week.
> 
> Paolo
> 
Paolo, Thomas,

Thanks again. I can confirm that Thomas' "timekeeping: Update timekeeper
before updating vsyscall and pvclock" indeed allows the kvmclock test to
pass on my machine.

--chris j arges
