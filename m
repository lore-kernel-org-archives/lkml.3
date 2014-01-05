Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaAEV36 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 16:29:58 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:35204 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaAEV35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 16:29:57 -0500
Date: Sun, 5 Jan 2014 21:29:51 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Gideon D'souza" <gidisrael@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How does a newbie find work?
Message-ID: <20140105212951.4e13b083@alan.etchedpixels.co.uk>
In-Reply-To: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
References: <CAPNrq4yXdbdfq4hrtZdZn_5UDPduGoTCNJb1-9u-Qf1nf2RgXQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I've made small contributions to other OSS projects before but now I'm
> at a loss for how to study the kernel code base, what to try to
> break/change to study how the kernel works.

LXR is useful for finding code and where it goes, but the kernel is a big
project. Don't assume anyone knows how of all it works.

> Is there some simple work a newbie like me can take up? Any maintainer
> need some grunt work done? Or perhaps someone could suggest a pet
> project I could try to understand things better? (Should I be learning
> how to write device drivers?)
> 
> Things that are very interesting to me so far are the KVM and the Scheduler.

Then I would fiddle with KVM and the scheduler !

Alan
