Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaFFJCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:02:47 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:37528 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFFJCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:02:45 -0400
Date: Fri, 6 Jun 2014 10:02:42 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Josh Triplett <josh@joshtriplett.org>, Jann Horn <jann@thejh.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
In-Reply-To: <538FA4C7.2050206@zytor.com>
Message-ID: <alpine.LFD.2.11.1406060457410.18344@eddie.linux-mips.org>
References: <20140509191914.GA7286@jtriplet-mobl1> <20140510070742.GE6099@debjann.fritz.box> <20140510193246.GA12079@thin> <20140511125006.GA16197@debjann.fritz.box> <20140511210514.GB6056@thin> <alpine.LFD.2.11.1406011101400.30121@eddie.linux-mips.org>
 <538FA4C7.2050206@zytor.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2014, H. Peter Anvin wrote:

> > Also IIRC PCI-PCI bridges only forward port I/O space accesses 
> > within the low 64kB.
> 
> Not true.

 It must have been an implementation-specific constraint then (e.g. 
DECchip 21050), it's been a while since I looked into it.  Thanks for 
straightening me out.

  Maciej
