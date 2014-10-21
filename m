Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585AbaJUNYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:24:34 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43209 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932505AbaJUNYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:24:33 -0400
Message-ID: <54465E8C.6030302@electrozaur.com>
Date: Tue, 21 Oct 2014 16:24:28 +0300
From: Boaz Harrosh <ooo@electrozaur.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jeff Garzik <jgpobox@gmail.com>, Jeff Garzik <jgarzik@pobox.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        osd-dev@open-osd.org
Subject: Re: state of the osdblk driver?
References: <20141021120653.GA9530@infradead.org> <CAFtxgO5cPNTMqyY5Foqp_Y+pqCH=zTiatREn-4xRCTm8o5GLwA@mail.gmail.com> <544655E8.8070004@electrozaur.com> <20141021130118.GA6122@infradead.org>
In-Reply-To: <20141021130118.GA6122@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 04:01 PM, Christoph Hellwig wrote:
<>
> 
> I'm mostly just trying to figure out if anyone cares.  Would you be
> willing to sign up as a maintainer, and maybe even look into a blk-mq
> conversion?  I'd be happy to help to answer questions and review it.
> 

I thought I was kind of am ;-) .

Good point I will put it on my list of things to do. Meanwhile can
I help you with the immediate problem of the tagging? could you do
something most brutal that even removes the tag support, just to
get you going?

And speaking of osdblk. Should it be its own full blown driver
or should it be under dm ? I know that at some LSF people said
it is better placed there? Specially since for a long time I wanted
to base it over ORE and not directly libosd so to support
RAID0/1/5/6 under the one simple block device.

> 
> Not sure what exactly you mean, but I'm open to any serious proposal to
> get rid of not actually usable cruft in old SCSI HBA drivers.  Feel
> free to send a proposal to linux-scsi - I was planning to come up with
> one of my own, but never got to it.
> 

Yes exactly that!
I wish I could have the time, perhaps one day I will. There is so much
more cleaning I can see.

Thanks Christoph
Boaz

