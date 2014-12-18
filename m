Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaLRVxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:53:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56919 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaLRVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:53:29 -0500
Date: Thu, 18 Dec 2014 13:53:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Hariharan Rangasamy <hariharanrangasamy@gmail.com>
Cc: marek.belisko@gmail.com, gregkh@linuxfoundations.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH] Staging: ft1000: ft1000_hw.c:  replaced asm
 header includes with linux headers
Message-ID: <20141218215328.GA9128@kroah.com>
References: <1418928322.6387.4.camel@hari-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418928322.6387.4.camel@hari-laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 12:15:22AM +0530, Hariharan Rangasamy wrote:
> 
> used #include <linux/io.h> instead of <asm/io.h>
> used #include <linux/bitops.h> instead of <asm/bitops.h>
> 
> Signed-off-by: Hariharan Rangasamy <hariharanrangasamy@gmail.com>

Your subject line looks crazy, not to mention you used my wrong email
address :(

Please fix up and resend.

thanks,

greg k-h
