Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbaCaKSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:18:42 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55016 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaCaKSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:18:40 -0400
Date: Mon, 31 Mar 2014 11:18:33 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Struan Bartlett <struan.bartlett@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Support for netconsole as default tty/console?
Message-ID: <20140331111833.76af70e0@alan.etchedpixels.co.uk>
In-Reply-To: <87r45lqcm7.fsf@igel.home>
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
	<87r45lqcm7.fsf@igel.home>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2014 15:54:24 +0100
Andreas Schwab <schwab@linux-m68k.org> wrote:

> Struan Bartlett <struan.bartlett@gmail.com> writes:
> 
> > Adding console=netconsole to the command line does not appear to have
> > the desired effect. I am not sure if this is because netconsole,
> > unlike the serial console, does not provide a tty. Can anyone advise
> > if this understanding is correct? If so, is there an independent
> > solution to this problem?
> 
> It should not be hard to add a tty driver to netconsole, there are many
> examples to borrow from.

Samo Pogacnik added a generic solution a few years ago. The ttyprintk
driver provides you with a tty/console whose 'hardware' is printk and
thus whatever system log device you are using.

Alan
