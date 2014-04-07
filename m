Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbaDGUyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 16:54:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39504 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187AbaDGUyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 16:54:31 -0400
Date: Mon, 7 Apr 2014 13:56:59 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Fabio Falzoi <fabio.falzoi84@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] Staging: rts5139: pr_warn(...) in place of
 printk(KERN_WARNING ...)
Message-ID: <20140407205659.GA7966@kroah.com>
References: <20140407003341.GA13365@kroah.com>
 <1396902468-27906-1-git-send-email-fabio.falzoi84@gmail.com>
 <1396902468-27906-5-git-send-email-fabio.falzoi84@gmail.com>
 <1396902887.2874.62.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396902887.2874.62.camel@joe-AO722>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 07, 2014 at 01:34:47PM -0700, Joe Perches wrote:
> On Mon, 2014-04-07 at 22:27 +0200, Fabio Falzoi wrote:
> > All printk(KERN_WARNING ...) replaced with pr_warn(...).
> 
> Please remove the RTS51X_TIP prefix and and and use
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> before any #include so that pr_<level> uses
> are prefixed in a standard way.


Feel free to do this as a follow-on patch, I'll take this one as-is, as
it is better than what we have currently...

thanks,

greg k-h
