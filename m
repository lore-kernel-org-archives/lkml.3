Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab3LaFSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 00:18:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50959 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab3LaFSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 00:18:47 -0500
Date: Mon, 30 Dec 2013 21:19:36 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jiri Slaby <jslaby@suse.cz>, stable <stable@vger.kernel.org>,
        linux-serial@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/2] TTY: pmac_zilog, check existence of ports in
 pmz_console_init()
Message-ID: <20131231051936.GA29909@kroah.com>
References: <1385135247-9068-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdVcqiNQiMHD3pgRWUzt7n3+F0dwmeXVnmZtgCxyo=GmFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVcqiNQiMHD3pgRWUzt7n3+F0dwmeXVnmZtgCxyo=GmFw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 24, 2013 at 03:39:50PM +0100, Geert Uytterhoeven wrote:
> On Fri, Nov 22, 2013 at 4:47 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
> > When booting a multi-platform m68k kernel on a non-Mac with "console=ttyS0"
> > on the kernel command line, it crashes with:
> 
> Can we please get this in stable, too?
> 
> commit dc1dc2f8a5dd863bf2e79f338fc3ae29e99c683a

Now applied, thanks.

greg k-h
