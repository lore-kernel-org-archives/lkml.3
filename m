Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab3CHRry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 12:47:54 -0500
Received: from mail-ia0-f178.google.com ([209.85.210.178]:55296 "EHLO
	mail-ia0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933577Ab3CHRrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 12:47:52 -0500
Date: Fri, 8 Mar 2013 09:48:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: syamsidhardh@gmail.com, linux-kernel@vger.kernel.org, jslaby@suse.cz,
        Syam Sidhardhan <s.syam@samsung.com>
Subject: Re: [PATCH v1] tty: ipwireless: Remove redundant NULL check before
 kfree
Message-ID: <20130308174824.GB13276@kroah.com>
References: <1362601044-6228-1-git-send-email-s.syam@samsung.com>
 <alpine.LRH.2.00.1303081425410.7777@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1303081425410.7777@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 08, 2013 at 02:26:43PM +0100, Jiri Kosina wrote:
> On Thu, 7 Mar 2013, syamsidhardh@gmail.com wrote:
> 
> > From: Syam Sidhardhan <s.syam@samsung.com>
> > 
> > kfree on NULL pointer is a no-op.
> > 
> > Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> 
> With my ipwireless maintainer hat on:
> 
> 	Acked-by: Jiri Kosina <jkosina@suse.cz>
> 
> Greg, could you please take it through tty tree?

Ok, will do.

thanks,

greg k-h
