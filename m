Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaFLUsn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:48:43 -0400
Received: from g2t2354.austin.hp.com ([15.217.128.53]:11244 "EHLO
	g2t2354.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058AbaFLUsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:48:42 -0400
X-Greylist: delayed 1382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Jun 2014 16:48:42 EDT
Message-ID: <1402606118.2627.14.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 0/2] Fix subject line
From: Davidlohr Bueso <davidlohr@hp.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Wahib Faizi <wahibfaizi@gmail.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jun 2014 13:48:38 -0700
In-Reply-To: <20140612203534.GA28328@kroah.com>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
	 <1402602019-12819-1-git-send-email-wahibfaizi@gmail.com>
	 <1402604734.2627.10.camel@buesod1.americas.hpqcorp.net>
	 <20140612203534.GA28328@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 13:35 -0700, Greg Kroah-Hartman wrote:
> On Thu, Jun 12, 2014 at 01:25:34PM -0700, Davidlohr Bueso wrote:
> > On Thu, 2014-06-12 at 23:40 +0400, Wahib Faizi wrote:
> > > Fix coding style issues detected by checkpatch.pl in usbip_host_driver.c.
> > 
> > Sorry but unless bundled with something more meaningful, I really don't
> > see the value in these changes. I certainly don't want to discourage
> > folks or anything, but just testing other patches is a lot more helpful
> > than this. 
> 
> When the staging code is still needing basic fixes like this, it is
> "meaningful" to do patches that clean up stuff like this.  That's what
> the staging tree is for.

Sure, but "making checkpatch happy just to make checkpatch happy" isn't
a good justification, even for staging. Patch 1 does have value in that
it helps avoid silly bugs, but take patch 2/2, we end-up saving just a
few spaces... Anyways, just my 2 cents.

Thanks,
Davidlohr

