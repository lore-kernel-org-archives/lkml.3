Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbaEDBOX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 21:14:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58999 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbaEDBOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 21:14:21 -0400
Date: Sat, 3 May 2014 20:27:35 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Christian Engelmayer <cengelma@gmx.at>
Cc: devel@driverdev.osuosl.org, florian.c.schilhabel@googlemail.com,
        linux-kernel@vger.kernel.org, Larry.Finger@lwfinger.net,
        alexandre.f.demers@gmail.com
Subject: Re: [PATCH] staging: rtl8712: fix potential leaks in r8712_set_key()
Message-ID: <20140504002735.GA16794@kroah.com>
References: <20140501235402.48ced880@spike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501235402.48ced880@spike>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 11:54:02PM +0200, Christian Engelmayer wrote:
> Fix potential leaks in the error paths of r8712_set_key(). In case the
> algorithm specific checks fail, the function returns without enqueuing
> or freeing the already allocated command and parameter structs. Use a
> centralized exit path and make sure that all memory is freed correctly.
> Detected by Coverity - CID 144370, 144371.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
> ---
> Compile tested and applies against branch staging-next of tree
> git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

This doesn't apply either, and neither does one of your other patches,
what is going on?

Can you just refresh all of the outstanding patches you have sent me
that I have not applied and resend them?

thanks,

greg k-h
