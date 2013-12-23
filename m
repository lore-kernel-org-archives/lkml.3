Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3LWA1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 19:27:41 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:56232 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756362Ab3LWA1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 19:27:40 -0500
Date: Mon, 23 Dec 2013 09:27:32 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq-renesas-irqc: simplify irq_set_type() method
Message-ID: <20131223002729.GB25868@verge.net.au>
References: <201312140309.31407.sergei.shtylyov@cogentembedded.com>
 <20131219082453.GA12239@verge.net.au>
 <CANqRtoT9-Pp+6p4gWa=uOh9Wdw8JmxXcduqTiqBApaPbr3YYng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANqRtoT9-Pp+6p4gWa=uOh9Wdw8JmxXcduqTiqBApaPbr3YYng@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:53:32PM +0900, Magnus Damm wrote:
> On Thu, Dec 19, 2013 at 5:24 PM, Simon Horman <horms@verge.net.au> wrote:
> > On Sat, Dec 14, 2013 at 03:09:31AM +0300, Sergei Shtylyov wrote:
> >> Value 0 of the sense  selection field of CONFIG_n register means "disable event
> >> detection" and serves in irqc_sense[] for marking the invalid values of the IRQ
> >> type (by just omitting initializers). There is no need for INTC_IRQ_SENSE_VALID
> >> and hence INTC_IRQ_SENSE() as all field values matching to the  valid IRQ types
> >> are non-zero anyway.
> >>
> >> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> >
> > Magnus, could you review this?
> 
> The patch is IMO only cosmetic so I can't say I care that much. But
> since you ask. =)
> 
> Acked-by: Magnus Damm <damm@opensource.se>

Thanks, I have queued this up.
