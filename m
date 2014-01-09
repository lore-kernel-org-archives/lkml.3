Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602AbaAISio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 13:38:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbaAISii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:38:38 -0500
Date: Thu, 9 Jan 2014 10:39:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Borg <jdb@sitrep3.com>
Cc: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20140109183909.GA10563@kroah.com>
References: <1388425244-10017-1-git-send-email-jdb@sitrep3.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388425244-10017-1-git-send-email-jdb@sitrep3.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 05:40:44PM +0000, Joe Borg wrote:
> >From 6d9f6446434c4021cc9452e31c374ac50e08f0f9 Mon Sep 17 00:00:00 2001
> From: Joe Borg <root@josephb.org>

This isn't matching your "from:" line on your email, why should I trust
it?

And doing kernel work as 'root'?  That's not a good idea for lots of
reasons...

> Date: Mon, 30 Dec 2013 15:35:08 +0000
> Subject: [PATCH 62/62] DAS1800: Fixing error from checkpatch.
> 
> Fixed pointer typeo; foo * bar should be foo *bar.
> 
> Signed-off by Joe Borg <root@josephb.org>

What happened to your Subject:?

And why is the whole git header in the email, please use git send-email
so that I don't have to hand-edit the body of the email to apply it.

Can you please fix this up and resend?

thanks,

greg k-h
