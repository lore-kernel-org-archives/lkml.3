Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182AbaLKTUW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 14:20:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaLKTUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 14:20:21 -0500
Message-ID: <1418325069.23374.31.camel@t520.localdomain>
Subject: Re: arm64 hitting BUG in arch_timer.h
From: Mark Salter <msalter@redhat.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Sonny Rao <sonnyrao@chromium.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 11 Dec 2014 14:11:09 -0500
In-Reply-To: <5489E9DA.8000504@cogentembedded.com>
References: <1418245000.23374.26.camel@t520.localdomain>
	 <5489E9DA.8000504@cogentembedded.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-11 at 22:00 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> On 12/10/2014 11:56 PM, Mark Salter wrote:
> 
> > Using Linus' tree from this morning, I am hitting:
> 
> >     [    0.000000] BUG: failure at ./arch/arm64/include/asm/arch_timer.h:112/arch_counter_get_cntpct!
> 
> > This is triggered by commit 0b46b8a718 ("clocksource: arch_timer: Fix
> > code to use physical timers when requested") which addresses an armv7
> > problem. Arm64 wants to always use a virtual timer. I used this to avoid
> > the BUG and get a booting kernel:
> 
>     You didn't sign off on the patch, so it can't be applied.
> 
> [...]
> 
> WBR, Sergei
> 

Right. That was more for discussion. I wasn't sure if that was the best
way to fix the problem so I just included what I did to work around it.
As it turns out, I wasn't the first to spot the problem or come up with
a patch. So, the first patch will go in without my further involvement.


