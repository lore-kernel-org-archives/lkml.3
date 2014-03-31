Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaCaMcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 08:32:15 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55161 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbaCaMcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 08:32:14 -0400
Date: Mon, 31 Mar 2014 13:32:04 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Andreas Schwab <schwab@suse.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Support for netconsole as default tty/console?
Message-ID: <20140331133204.0c9d8358@alan.etchedpixels.co.uk>
In-Reply-To: <mvm4n2ehdes.fsf@hawking.suse.de>
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com>
	<87r45lqcm7.fsf@igel.home>
	<20140331111833.76af70e0@alan.etchedpixels.co.uk>
	<mvm4n2ehdes.fsf@hawking.suse.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2014 12:26:35 +0200
Andreas Schwab <schwab@suse.de> wrote:

> One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk> writes:
> 
> > Samo Pogacnik added a generic solution a few years ago. The ttyprintk
> > driver provides you with a tty/console whose 'hardware' is printk and
> > thus whatever system log device you are using.
> 
> Unfortunately it's an EXPERT setting, thus typically not avaiable.

It's however implemented and present. The rest is between you and the
relevant Kconfig maintainer. I'm sure you count as an expert ;-)

(and perhaps moving it into drivers/tty would also be sensible).

Alan
