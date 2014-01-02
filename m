Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaABV46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 16:56:58 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:53656 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478AbaABV4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 16:56:52 -0500
Date: Thu, 2 Jan 2014 13:56:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: Geert Uytterhoeven <geert@linux-m68k.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Question on compiler warning
In-Reply-To: <52C21CE3.3020402@lwfinger.net>
Message-ID: <alpine.DEB.2.02.1401021354400.21537@chino.kir.corp.google.com>
References: <52C21CE3.3020402@lwfinger.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Dec 2013, Larry Finger wrote:

> + /scratch/kisskb/src/drivers/net/wireless/b43/phy_n.c: warning: 'val_addr'
> may be used uninitialized in this function [-Wuninitialized]: => 178:21
> 
> This warning does not show up on any of my compilers, and it should not as the
> initialization and usage of that variable both take place in conditional
> branches that are testing exactly the same pointer.
> 

You may not be compiling this file depending on your .config or you may 
have a different setting for CONFIG_CC_OPTIMIZE_FOR_SIZE.
