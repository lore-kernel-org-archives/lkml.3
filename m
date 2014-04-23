Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaDWAZz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 20:25:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50886 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaDWAZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 20:25:53 -0400
Date: Tue, 22 Apr 2014 17:28:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-serial@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        peter@hurleysoftware.com, m-karicheri2@ti.com, b32955@freescale.com,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] tty: serial: add missing braces
Message-ID: <20140423002843.GC24603@kroah.com>
References: <1395343807-21618-1-git-send-email-balbi@ti.com>
 <20140422142256.GC5524@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422142256.GC5524@saruman.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 09:22:56AM -0500, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Mar 20, 2014 at 02:29:57PM -0500, Felipe Balbi wrote:
> > per CodingStyle we should have those braces, no
> > functional changes.
> > 
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> 
> Greg, do you want me to refresh and resend this series ?

If there are conflicts with my current tree, sure, I'd love to have
that.  I should be trying to dig out from my patch backlog for 3.16-rc1
by the end of this week...

thanks,

greg k-h
