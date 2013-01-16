Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757688Ab3APGPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:15:39 -0500
Received: from mail.kernel.org ([198.145.19.201]:35518 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab3APGPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:15:37 -0500
Date: Tue, 15 Jan 2013 22:16:36 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] switch arc-uart to devicetree based probing
Message-ID: <20130116061636.GA5680@kroah.com>
References: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357885223-19243-1-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 11:50:19AM +0530, Vineet Gupta wrote:
> Hi,
> 
> As part of converting ARC Port to devicetree infrastructure, the following
> series converts the arc-uart driver to DT.
> 
> * The first patch is a bug-fix which showed up in the process as DT based
>   platform devices by default have -ve id
> * Next two prepare the driver for forthcoming DT changes.
> * Last one contains the DT bindings and driver using those.
> 
> Couple of points worth mentioning:
> * The earlyprintk portion of driver still relies on static platform data
>   we would need some earlyprintk handling in of_fdt_* to clean it up properly
> * Two of the three platform data instances are now retrieved from DT.
>   However one still needs to be dynamically passed by platform (using
>   of_dev_auxdata) as we want to run same image in simulator and hardware
> 
> Tested on in-works ARC 3.8 port.
> 
> P.S. Greg, can this be treated as a bug-fix for 3.8

No, because it is not a bugfix, but a new feature, sorry.

greg k-h
