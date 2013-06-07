Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab3FGNrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:47:42 -0400
Received: from 1wt.eu ([62.212.114.60]:36146 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290Ab3FGNrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:47:40 -0400
Date: Fri, 7 Jun 2013 15:47:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: Lotfi Manseur <lotfi.manseur@gmail.com>
Cc: stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wojciech M Zabolotny <W.Zabolotny@elka.pw.edu.pl>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        Lotfi Manseur <lotfi.manseur@imag.fr>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial/ftdi_sio.c Fix kernel oops
Message-ID: <20130607134729.GC19006@1wt.eu>
References: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370610872-1309-1-git-send-email-lotfi.manseur@imag.fr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 03:14:32PM +0200, Lotfi Manseur wrote:
> Handle null termios in ftdi_set_termios(), introduced in
> commit 552f6bf1bb0eda0011c0525dd587aa9e7ba5b846
> This has been corrected in the mainline by
> commits c515598e0f5769916c31c00392cc2bfe6af74e55 and
> a816e3113b63753c330ca4751ea1d208e93e3015.
> 
> This is to be fixed in longterm 2.6.32.60 and 3.4.47.
> This bug has been found with coccinelle.

Thank you Lofti, I have queued it now.

Best regards,
Willy

