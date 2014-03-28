Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaC1Grg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:47:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47021 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbaC1Grf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:47:35 -0400
Date: Thu, 27 Mar 2014 23:49:26 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Insop Song <insop.song@gainspeed.com>
Cc: insop.song@gmail.com, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] Remove warning printk
Message-ID: <20140328064926.GB13510@kroah.com>
References: <1395978883-18723-1-git-send-email-insop.song@gainspeed.com>
 <1395978883-18723-2-git-send-email-insop.song@gainspeed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395978883-18723-2-git-send-email-insop.song@gainspeed.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 08:54:43PM -0700, Insop Song wrote:
> Found from build with option -Werror=date-time
> 
> Signed-off-by: Insop Song <insop.song@gainspeed.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Did Arnd really sign off on this?

And what is with the "odd" subject, your first email should have been
the subject of this one.  We don't need a "cover letter" for a one-patch
email sequence.

Care to fix this up and resend?

thanks,

greg k-h
