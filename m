Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3J2Puo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:50:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758183Ab3J2Pul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 11:50:41 -0400
Date: Tue, 29 Oct 2013 08:50:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Chuong Ngo <cngo.github@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: bcm:  Removed a developer debug
 statement.
Message-ID: <20131029155040.GA3169@kroah.com>
References: <1382555480-26605-1-git-send-email-cngo.github@gmail.com>
 <20131023220245.GF9378@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131023220245.GF9378@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 01:02:45AM +0300, Dan Carpenter wrote:
> On Wed, Oct 23, 2013 at 03:11:20PM -0400, Chuong Ngo wrote:
> > Removed a developer debug statement per the TODO list.  Additionally, removed braces for the if-statement to match coding style.
> 
> Line wrap the changelog at 72 characters.  You don't really need to
> mention the removed braces because that's too obvious to bother
> commenting on.
> 
> My guess is that Greg will probably be willing to apply this as is so
> don't worry about resending unless he requests it.  (He normally seems
> to let newbies get by with one line wrapping warning before he starts
> making you redo it).

Yes, I'll fix it this time, but Chuong, please be more careful next
time.

greg k-h

