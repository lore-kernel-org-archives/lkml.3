Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab3HLVHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:07:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3HLVHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:07:21 -0400
Date: Mon, 12 Aug 2013 14:07:20 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jens Frederich <jfrederich@gmail.com>
Cc: devel@driverdev.osuosl.org, jon.nettleton@gmail.com, dsd@laptop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: olpc_dcon: more big endian conformity
Message-ID: <20130812210720.GA10370@kroah.com>
References: <1375650256-12411-1-git-send-email-jfrederich@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375650256-12411-1-git-send-email-jfrederich@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 04, 2013 at 11:04:16PM +0200, Jens Frederich wrote:
> Using an int which is casted to unsigned char as inbuf is messy.
> The code won't work on big endian systems.  The patch should fix
> this.
> 
> Signed-off-by: Jens Frederich <jfrederich@gmail.com>

This patch doesn't apply at all, can you refresh it against my
staging-next branch and resend it so that I can apply it?

thanks,

greg k-h
