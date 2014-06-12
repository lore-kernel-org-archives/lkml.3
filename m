Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaFLUbp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:31:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFLUbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:31:43 -0400
Date: Thu, 12 Jun 2014 13:35:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Wahib Faizi <wahibfaizi@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] Fix subject line
Message-ID: <20140612203534.GA28328@kroah.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402602019-12819-1-git-send-email-wahibfaizi@gmail.com>
 <1402604734.2627.10.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402604734.2627.10.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 01:25:34PM -0700, Davidlohr Bueso wrote:
> On Thu, 2014-06-12 at 23:40 +0400, Wahib Faizi wrote:
> > Fix coding style issues detected by checkpatch.pl in usbip_host_driver.c.
> 
> Sorry but unless bundled with something more meaningful, I really don't
> see the value in these changes. I certainly don't want to discourage
> folks or anything, but just testing other patches is a lot more helpful
> than this. 

When the staging code is still needing basic fixes like this, it is
"meaningful" to do patches that clean up stuff like this.  That's what
the staging tree is for.

thanks,

greg k-h
