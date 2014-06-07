Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaFGWD0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 18:03:26 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56967 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbaFGWDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 18:03:25 -0400
Date: Sat, 7 Jun 2014 23:02:39 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bin Wang <binw@marvell.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Norbert Ciosek <norbertciosek@gmail.com>
Subject: Re: [GIT PULL] char/misc driver patches for 3.16-rc1
Message-ID: <20140607230239.4a801e27@alan.etchedpixels.co.uk>
In-Reply-To: <20140607104232.GC23815@amd.pavel.ucw.cz>
References: <20140603054434.GB2921@kroah.com>
	<CA+55aFyQ=iSMnLAywumYpGBOBiqxL2qO9u9OsTF=RFfYBnz10g@mail.gmail.com>
	<20140603170244.GA22867@kroah.com>
	<CA+55aFwMEigYZGeF4sFTSpmnvb8YQ3hOndjNrd9ObL2EdOptgQ@mail.gmail.com>
	<20140603182555.GA28541@kroah.com>
	<20140607104232.GC23815@amd.pavel.ucw.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> At the very least, we have (CAP_SYS_ADMIN?) should be required before
> allowing root to compromise kernel, no?

CAP_SYS_RAWIO for anything that can compromise the kernel itself.
 
