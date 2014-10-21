Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652AbaJUM4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:56:55 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:46849 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaJUM4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:56:54 -0400
MIME-Version: 1.0
In-Reply-To: <544655E8.8070004@electrozaur.com>
References: <20141021120653.GA9530@infradead.org>
	<CAFtxgO5cPNTMqyY5Foqp_Y+pqCH=zTiatREn-4xRCTm8o5GLwA@mail.gmail.com>
	<544655E8.8070004@electrozaur.com>
Date: Tue, 21 Oct 2014 08:56:53 -0400
Message-ID: <CAFtxgO7xfnMOc2ARYi+y=HnU3cc3818daeQ2RbDJMe32sMUxTA@mail.gmail.com>
Subject: Re: state of the osdblk driver?
From: Jeff Garzik <jgpobox@gmail.com>
To: Boaz Harrosh <ooo@electrozaur.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        osd-dev@open-osd.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 8:47 AM, Boaz Harrosh <ooo@electrozaur.com> wrote:
> [Just that I thought we don't do that. I can show you a dozen
>  ISA scsi LLD controllers which are a complete pain in the neck
>  with a all subsection core support. There is not a single system
>  on the planet that has this even possible, yet we do not remove
>  them nor the ISA bus crap. osdblk at least is a SW only exercise
>  that can be very much valid in any system.


+1 also a fair point.
