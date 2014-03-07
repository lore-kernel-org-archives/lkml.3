Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaCGFwF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:52:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38623 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbaCGFwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 00:52:02 -0500
Date: Thu, 6 Mar 2014 21:52:31 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: jon@ringle.org
Cc: jslaby@suse.cz, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH] RFC: WIP: sc16is7xx.c
Message-ID: <20140307055231.GA32019@kroah.com>
References: <1394159746-1729-1-git-send-email-jon@ringle.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394159746-1729-1-git-send-email-jon@ringle.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2014 at 09:35:46PM -0500, jon@ringle.org wrote:
> From: Jon Ringle <jringle@gridpoint.com>
> 
> I am requesting comments on this serial driver.
> I am currently having some latency issues with it where I experience
> packet loss at speed of 19200.
> 
> I welcome any and all comments.

The basic coding style problems make it hard to read to be able to help
review it, sorry.

Yes, brains have patterns, you want to follow the same patterns as
others, it matters.

thanks,

greg k-h
