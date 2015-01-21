Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbbAURvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:51:48 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:54097 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753601AbbAURvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:51:38 -0500
Date: Wed, 21 Jan 2015 17:44:22 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Siddhartha De <siddhartha.de87@gmail.com>
Cc: kernelnewbies@kernelnewbies.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Question about kernel interfaces
Message-ID: <20150121174422.260bc3e3@lxorguk.ukuu.org.uk>
In-Reply-To: <CADxyqMEjs7Xpy7Xqi7zbyOtCwNWfT1bK22Paf3wSMP8YEVjyUQ@mail.gmail.com>
References: <CADxyqMFnDnFNvTL7Yuzd-1WP9RRddFYAd7UVXmLT2SOMRmOx9g@mail.gmail.com>
	<CADxyqMHXMjXPVnGSpQSS=_FUpH=Hz-=P1FbcFfJ8Omp3k74dGA@mail.gmail.com>
	<20150108134849.671ee761@lxorguk.ukuu.org.uk>
	<CADxyqME4=vnZh4J8BDw63r6L=hA8OpO4GJWxuuOgwuFwHb+8Lg@mail.gmail.com>
	<20150114163317.46a1ecec@lxorguk.ukuu.org.uk>
	<CADxyqMGtew47Gfzq=1u46qjkLsn+AkB-fGWbAtODAbHgi3DM9g@mail.gmail.com>
	<CADxyqMEjs7Xpy7Xqi7zbyOtCwNWfT1bK22Paf3wSMP8YEVjyUQ@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Jan 2015 15:03:55 +0530
> Let's say you need to call an ioctl from a shell script ( I know its a
> very rare use case but please bear with me ... :) )
> 
> So the current way of doing it is probably to write a C program which
> actually calls the ioctl and then call the C program from the shell
> script ...

That's how Unix is designed yes. It means that the ioctl internals are
hidden from the scripts and the tools provided can be used instead.

> and the IOCTL_EJECT ioctl would get called on /dev/cdrom
> that is ioctl ( &handle_to_/dev/cdrom , IOCTL_EJECT , &some_buffer )
> would get called ( by our translator running as a separate program or
> as a service daemon )

You can just run "eject". It knows about all the details of doing an
eject.
 
The equivalent of a "library" in shell scripts is a program. Small,
simple tools that do one job and do it right, or at least before GNU got
hold of them 8)

Alan
