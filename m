Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbaGIS5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:57:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47258 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaGIS5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:57:36 -0400
Date: Wed, 9 Jul 2014 12:02:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: dgap: removes redundant null check and change
 paramter for dgap_maxcps_room()
Message-ID: <20140709190200.GA8113@kroah.com>
References: <20140707012754.GA26042@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707012754.GA26042@devel.8.8.4.4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 10:27:54AM +0900, Daeseok Youn wrote:
> Null checks for tty, un and ch are already done by caller,
> so replace parameter "tty" with "ch" and "un".
> 
> And also use a pointer for returning new bytes_available instead of
> return variable.

Why make that change?  It's nicer to return a real value where ever
possible.  That's more like other "room" functions in the tty layer.

Care to fix this up to just do the first change you made to the function
instead?

thanks,

greg k-h
