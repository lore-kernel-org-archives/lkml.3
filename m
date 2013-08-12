Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3HLSj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:39:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55540 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab3HLSjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:39:55 -0400
Date: Mon, 12 Aug 2013 11:39:54 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] tile: various console improvements
Message-ID: <20130812183954.GA19875@kroah.com>
References: <201308071458.r77EwWuV013082@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308071458.r77EwWuV013082@farm-0012.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 02:11:21PM -0400, Chris Metcalf wrote:
> This change improves and cleans up the tile console.
> 
> - We enable HVC_IRQ support on tilegx, with the addition of a new
>   Tilera hypervisor API for tilegx to allow a console IPI.  If IPI
>   support is not available we fall back to the previous polling mode.
> 
> - We simplify the earlyprintk code to use CON_BOOT and eliminate some
>   of the other supporting earlyprintk code.
> 
> - A new tile_console_write() primitive is used to send output to
>   the console and is factored out of the hvc_tile driver.
>   This lets us support a "sim_console" boot argument to allow using
>   simulator hooks to send output to the "console" as a slightly
>   faster alternative to emulating the hardware more directly.
> 
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
