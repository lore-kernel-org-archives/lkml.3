Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3DVUvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 16:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab3DVUvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 16:51:12 -0400
Message-ID: <5175A29E.1070704@redhat.com>
Date: Mon, 22 Apr 2013 16:50:38 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130402 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jiannan Ouyang <ouyang@cs.pitt.edu>, LKML <linux-kernel@vger.kernel.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Avi Kivity <avi.kivity@gmail.com>, Gleb Natapov <gleb@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Andrew Jones <drjones@redhat.com>, Karen Noel <knoel@redhat.com>
Subject: Re: Preemptable Ticket Spinlock
References: <CAJocwccu5QQyuKRvgNyPSFz2K_rzCW419W9-XdSUYOL7+KqQKg@mail.gmail.com>  <51745650.9050204@redhat.com> <1366631460.4443.3.camel@laptop>  <51753289.70406@redhat.com> <1366660147.6454.6.camel@laptop>  <517595FA.800@redhat.com> <1366661294.6454.18.camel@laptop>  <51759E43.2080003@redhat.com> <1366663475.8337.10.camel@laptop> <1366663714.8337.12.camel@laptop>
In-Reply-To: <1366663714.8337.12.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2013 04:48 PM, Peter Zijlstra wrote:

> Hmm.. it looked like under light overcommit the paravirt ticket lock
> still had some gain (~10%) and of course it brings the fairness thing
> which is always good.
>
> I can only imagine the mess unfair + vcpu preemption can bring to guest
> tasks.

If you think unfairness + vcpu preemption is bad, you haven't
tried full fairness + vcpu preemption :)

-- 
All rights reversed
