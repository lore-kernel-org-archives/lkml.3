Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756719Ab3CYDSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:18:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:36702 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3CYDSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <514FBD6E.2030706@cn.fujitsu.com>
References: <CAAO_Xo6=2PKumrxjb1XthsiVVFJcz33o5wf2OyXN9pPdu1GCRA@mail.gmail.com>
	<514FBD6E.2030706@cn.fujitsu.com>
Date: Mon, 25 Mar 2013 11:18:06 +0800
Message-ID: <CAAO_Xo7edAuiGQaXHuyWB5RPgPd5dDDRof3-d28eu+mryJkv+Q@mail.gmail.com>
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

> Seems you bind the nic irq to second and third cpu for the bit mask
> you set is 110, so now eth9's irq is working on the 3rd cpu.

> Have you ever tried irqbalance service? It may help to balance irq if the
> irq workload of 3rd cpu is too heavy.


I need the interrupts distribute over multiple cores, such as the
second and third, so i set the mask parameter to 0x3. But only one
core is handling the interrupts. As you can see, just the second cpu's
irq number has increased.

The irqbalance service has been stopped.

-- 
Regards,

Lenky
