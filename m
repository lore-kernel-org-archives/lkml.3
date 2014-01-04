Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaADUhB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 15:37:01 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:55540 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbaADUhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 15:37:00 -0500
Date: Sat, 4 Jan 2014 21:36:54 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How does a newbie find work?
Message-ID: <20140104213654.0f0b34f2@neptune.home>
In-Reply-To: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
References: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.22; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gideon,

On Sat, 04 January 2014 "Gideon D'souza" <gidisrael@gmail.com> wrote:
> I've been looking to hacking at the kernel for a long time now.
> 
> I've managed to have a good setup, build the latest stable kernel and
> boot from it. I've read some of the docs, Coding Styles etc and
> watched GregKH's talks on youtube. I'm also reading Robert Love's
> Linux Kernel Development.
> 
> 
> Id like now to get my hands dirty but I can't seem to find something
> simple to do. I posted to kernel janitors and kernel mentors, but no
> dice. The bugs list looks thoroughly contrived.
> 
> I've made small contributions to other OSS projects before but now I'm
> at a loss for how to study the kernel code base, what to try to
> break/change to study how the kernel works.
> 
> Is there some simple work a newbie like me can take up? Any maintainer
> need some grunt work done? Or perhaps someone could suggest a pet
> project I could try to understand things better? (Should I be learning
> how to write device drivers?)
> 
> Things that are very interesting to me so far are the KVM and the Scheduler.

Starting with writing some driver (or improving existing drivers) is one
option, though that wont get you doing work in relation with the scheduler
(maybe there is some minor driver-like work for KVM though, don't know).

A better start, and at least as useful is to read and review patches
flowing by that affect your areas of interest, test them and provide
feedback about possible bugs or improvements (proposing patches to fix
those if applicable or even just providing performance data [what
workloads benefit or suffer from given feature-patches and by how much]
for things like scheduler changes).

This way you will get to know the development process, maintainers
and the internals of the kernel in those areas - don't forget to subscribe
to the specific mailing lists!

Regards,
Bruno

> Regards,
> Gideon
