Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3FKG2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:28:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34701 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3FKG2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:28:43 -0400
Date: Mon, 10 Jun 2013 14:03:40 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lotfi Manseur <lotfi.manseur@gmail.com>
Cc: stable@vger.kernel.org, Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Lotfi Manseur <lotfi.manseur@imag.fr>, Willy Tarreau <w@1wt.eu>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial/ftdi_sio.c Fix kernel oops
Message-ID: <20130610210340.GB1602@kroah.com>
References: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:14:32PM +0200, Lotfi Manseur wrote:
> Handle null termios in ftdi_set_termios(), introduced in
> commit 552f6bf1bb0eda0011c0525dd587aa9e7ba5b846
> This has been corrected in the mainline by
> commits c515598e0f5769916c31c00392cc2bfe6af74e55 and

This commit showed up in 3.3, so it can't go into 3.4 at all.  Please be
more careful when asking for stable patches to be applied.  That is why
I want the _exact_ same patch to apply, don't try going and being smart
by mushing them together into something else, this would have obviously
not been correct for the 3.4 kernel at all.

greg k-h
