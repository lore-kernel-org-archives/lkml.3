Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934679Ab3FSKxU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 06:53:20 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:55390 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934011Ab3FSKxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 06:53:15 -0400
Date: Wed, 19 Jun 2013 12:52:59 +0200
From: Ralf Baechle <ralf@linux-mips.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 3/5] tty/8250_dw: Add support for OCTEON UARTS.
Message-ID: <20130619105259.GC9448@linux-mips.org>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
 <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com>
 <2302882.NVjP8DdXWY@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2302882.NVjP8DdXWY@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 12:01:06PM +0200, Arnd Bergmann wrote:

> This breaks building on 32 bit architectures as I found on my daily ARM
> builds: __raw_writeq cannot be defined on architectures that don't have
> native 64 bit data access instructions. It's also wrong to use the
> __raw_* variant, which is not guaranteed to be atomic and is not
> endian-safe.

I've dequeued the series from the mips-next tree until David has a chance
to fix this.

  Ralf
