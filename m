Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbbARASX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 19:18:23 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbbARASV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 19:18:21 -0500
Date: Sat, 17 Jan 2015 16:09:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Akira Hayakawa <ruby.wktk@gmail.com>
Cc: snitzer@redhat.com, ejt@redhat.com, dm-devel@redhat.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: writeboost: Add dm-writeboost
Message-ID: <20150118000952.GB26160@kroah.com>
References: <54A508F7.1020207@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A508F7.1020207@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 01, 2015 at 05:44:39PM +0900, Akira Hayakawa wrote:
> This patch adds dm-writeboost to staging tree.
> 
> dm-writeboost is a log-structured SSD-caching driver.
> It caches data in log-structured way on the cache device
> so that the performance is maximized.
> 
> The merit of putting this driver in staging tree is
> to make it possible to get more feedback from users
> and polish the codes.
> 
> v2->v3
> - rebased onto 3.19-rc2
> - Add read-caching support (disabled by default)
>   Several tests are pushed to dmts.
> - An critical bug fix
>   flush_proc shouldn't free the work_struct it's running on.
>   I found this bug while I am testing read-caching.
>   I am not sure why i didn't exhibit before but it's truly a bug.
> - Fully revised the README.
>   Now that we have read-caching support, the old README was completely obsolete.
> - Update TODO
>   Implementing read-caching is done.
> - bump up the copyright year to 2015
> - fix up comments
> 
> 
> Signed-off-by: Akira Hayakawa <ruby.wktk@gmail.com>

I need an ack from a dm developer before I can take this.

thanks,
greg k-h
