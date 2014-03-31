Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbaCaSdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 14:33:36 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51257 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbaCaSdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 14:33:35 -0400
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Support for netconsole as default tty/console?
Date: Mon, 31 Mar 2014 20:33:31 +0200
User-Agent: KMail/1.13.7 (Linux/3.14.0-rc7-00066-g774868c; KDE/4.12.3; x86_64; ; )
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Struan Bartlett <struan.bartlett@gmail.com>
References: <CAOte+=YgX=0dahqCS6-=yBLHnTjoJtii3Ycx4mhrj9SqNADZzg@mail.gmail.com> <87r45lqcm7.fsf@igel.home> <20140331111833.76af70e0@alan.etchedpixels.co.uk>
In-Reply-To: <20140331111833.76af70e0@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201403312033.31492.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 31 of March 2014, One Thousand Gnomes wrote:
> On Sat, 29 Mar 2014 15:54:24 +0100
> 
> Andreas Schwab <schwab@linux-m68k.org> wrote:
> > Struan Bartlett <struan.bartlett@gmail.com> writes:
> > > Adding console=netconsole to the command line does not appear to have
> > > the desired effect. I am not sure if this is because netconsole,
> > > unlike the serial console, does not provide a tty. Can anyone advise
> > > if this understanding is correct? If so, is there an independent
> > > solution to this problem?
> > 
> > It should not be hard to add a tty driver to netconsole, there are many
> > examples to borrow from.
> 
> Samo Pogacnik added a generic solution a few years ago. The ttyprintk
> driver provides you with a tty/console whose 'hardware' is printk and
> thus whatever system log device you are using.

Is there a way to get two devices working as console? For example I would like 
to have console on tty0 and on netconsole at the same time. Right now only 
one, last console gets all userspace messages.

> Alan

-- 
Arkadiusz Miśkiewicz, arekm / maven.pl
