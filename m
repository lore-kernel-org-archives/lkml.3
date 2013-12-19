Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab3LSJxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:53:40 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48485 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab3LSJxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:53:34 -0500
MIME-Version: 1.0
In-Reply-To: <20131219082453.GA12239@verge.net.au>
References: <201312140309.31407.sergei.shtylyov@cogentembedded.com>
	<20131219082453.GA12239@verge.net.au>
Date: Thu, 19 Dec 2013 18:53:32 +0900
Message-ID: <CANqRtoT9-Pp+6p4gWa=uOh9Wdw8JmxXcduqTiqBApaPbr3YYng@mail.gmail.com>
Subject: Re: [PATCH] irq-renesas-irqc: simplify irq_set_type() method
From: Magnus Damm <magnus.damm@gmail.com>
To: Simon Horman <horms@verge.net.au>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 5:24 PM, Simon Horman <horms@verge.net.au> wrote:
> On Sat, Dec 14, 2013 at 03:09:31AM +0300, Sergei Shtylyov wrote:
>> Value 0 of the sense  selection field of CONFIG_n register means "disable event
>> detection" and serves in irqc_sense[] for marking the invalid values of the IRQ
>> type (by just omitting initializers). There is no need for INTC_IRQ_SENSE_VALID
>> and hence INTC_IRQ_SENSE() as all field values matching to the  valid IRQ types
>> are non-zero anyway.
>>
>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
>
> Magnus, could you review this?

The patch is IMO only cosmetic so I can't say I care that much. But
since you ask. =)

Acked-by: Magnus Damm <damm@opensource.se>

Cheers,

/ magnus
