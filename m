Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaKDD6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:58:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37120 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaKDD6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:58:17 -0500
Date: Mon, 3 Nov 2014 19:57:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PULL REQUEST] remove .owner for most platform_drivers
Message-ID: <20141104035707.GA8718@kroah.com>
References: <20141021165441.GA1619@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021165441.GA1619@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:54:41PM +0200, Wolfram Sang wrote:
> Hi Greg,
> 
> as discussed at ELCE, here is my pull request for cleaning up all unneeded
> assignment of .owner for platform drivers. I used the following semantic patch
> to check that it only removes it when .owner gets initialized by the call to
> register the driver:

I've pulled this, and pushed it out in my driver-core-testing branch to
make sure nothing breaks.

Just to be sure, the 4 other patches you sent also need to go in here
for 3.19, right?  They were not included in this pull request?

thanks,

greg k-h
