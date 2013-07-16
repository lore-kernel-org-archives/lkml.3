Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab3GPGY7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 02:24:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:35288 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab3GPGY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 02:24:58 -0400
Date: Mon, 15 Jul 2013 23:24:52 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Greg KH <greg@kroah.com>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: KS Topic request: Handling the Stable kernel, let's dump the
 cc: stable tag
In-Reply-To: <20130715214422.GA2478@kroah.com>
Message-ID: <alpine.DEB.2.02.1307152319490.16723@nftneq.ynat.uz>
References: <1373916476.2748.69.camel@dabdike> <20130715214422.GA2478@kroah.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jul 2013, Greg KH wrote:

> I don't like this at all, just for the simple reason that it will push
> the majority of the work of stable kernel development on to the
> subsystem maintainers, who have enough work to do as it is.
>
> Stable tree stuff should cause almost _no_ extra burden on the kernel
> developers, because it is something that I, and a few other people, have
> agreed to do with our time.  It has taken me 8 _years_ to finally get
> maintainers to agree to mark stuff for the stable tree, and fine-tune a
> development process that makes it easy for us to do this backport work.

It's important to remember that the subsystem maintainers have essentially no 
input on how many stable trees there are or how long they are maintained.

That is entirely up to the people maintaining the stable trees.

Just because some crazy person ;-) decides to maintain 2.4 for many years 
doesn't mean that every subsystem maintainer needs to worry about backporting 
patches from 3.11 all the way back to 2.4. The fact that they are as willing as 
they are to review the results of the backports for problems in amazing.

David Lang
