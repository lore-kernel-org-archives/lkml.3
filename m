Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbaL1HaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 02:30:19 -0500
Received: from dsl-pw-ha2.btc-net.bg ([212.39.90.102]:51792 "HELO
	dsl-pw-ha2.btc-net.bg" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751249AbaL1HaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 02:30:16 -0500
From: =?koi8-r?B?8MzBzcXOIPDF1NLP1w==?= <plamen@petrovi.no-ip.info>
To: "'Juergen Gross'" <jgross@suse.com>, <linux-kernel@vger.kernel.org>
Cc: "'Thomas Gleixner'" <tglx@linutronix.de>
References: <000001d01f10$85f506f0$91df14d0$@petrovi.no-ip.info> <549EB88D.20403@suse.com> 
In-Reply-To: 
Subject: RE: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB 0.97 (GRUB Legacy)
Date: Sun, 28 Dec 2014 09:30:06 +0200
Message-ID: <000501d02270$1a6347e0$4f29d7a0$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="koi8-r"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQG2suHKZrsvgDolBSLOqRRrV87A3wFfzhn6Am+lIhacuP0bUA==
Content-Language: bg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Пламен Петров [mailto:plamen@petrovi.no-ip.info]
> Sent: Sunday, December 28, 2014 9:20 AM
> To: 'Juergen Gross'; 'linux-kernel@vger.kernel.org'
> Cc: 'Thomas Gleixner'
> Subject: RE: [BISECTED] 3.19-rc1 regression - kernel does not load in GRUB
> 0.97 (GRUB Legacy)
> 
> > -----Original Message-----
> > From: Juergen Gross [mailto:jgross@suse.com]
> > Sent: Saturday, December 27, 2014 3:48 PM
> > To: Пламен Петров; linux-kernel@vger.kernel.org
> > Cc: 'Thomas Gleixner'
> > Subject: Re: [BISECTED] 3.19-rc1 regression - kernel does not load in
> > GRUB
> > 0.97 (GRUB Legacy)
> >
...
> >
> > Can you boot with kernel option "nopat"?
> 
> Same as above - kernel command line options do not help, as they never get
> into play to even make a difference.
> 

Scratch the above, and sorry for my jump to conclusions instead of "First
Trying"T.

Adding "nopat" to the kernel command line options does make the previously
broken unpatched vanilla 3.19-rc1 kernel boot fine.

Does this mean that I should add "nopat" command line option to all VMs for
3.19?

> If you need the actual details of my setup or want me to try patches -
just
> ask.
> 
---------------------------------
Plamen Petrov

