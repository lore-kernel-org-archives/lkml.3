Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3CYDoJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:44:09 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55835 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab3CYDoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:44:08 -0400
MIME-Version: 1.0
In-Reply-To: <514FC385.4030008@cn.fujitsu.com>
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
	<514FBD6E.2030706@cn.fujitsu.com>
	<CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com>
	<514FC385.4030008@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 11:44:06 +0800
Message-ID: <CAAO_Xo7FbEsG=6pmcfUDyKtcPuPLTkNY+kUU+5hFnzciQBO-Aw@mail.gmail.com>
Subject: Re: Question: How to distribute the interrupts over multiple cores?
From: Lenky Gao <lenky.gao@gmail.com>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org, mingo@elte.hu,
        gorcunov@gmail.com, rusty@rustcorp.com.au, sivanich@sgi.com,
        agordeev@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 03/25/2013 11:18 AM, Lenky Gao wrote:
>> The irqbalance service has been stopped.
> So try start irqbalance to see what happen?
> It should help to give what you want ;-)

Using the irqbalance service to dynamically change the IRQ-bound? It's
seems a software solution. In my old machine, there is no this
problem. I need some information to explain why. Maybe is the
apic_physflat mode only support distribute the interrupts to one
processor, but i am not exactly sure if this is right? Or my E5504
Machine's hardware issue?

-- 
Regards,

Lenky
