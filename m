Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaFLVbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 17:31:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:44547 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaFLVa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 17:30:59 -0400
Date: Fri, 13 Jun 2014 00:30:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Wahib Faizi <wahibfaizi@gmail.com>
Subject: Re: [PATCH v3 0/2] Fix subject line
Message-ID: <20140612213045.GW5500@mwanda>
References: <1402569338-5709-1-git-send-email-wahibfaizi@gmail.com>
 <1402602019-12819-1-git-send-email-wahibfaizi@gmail.com>
 <1402604734.2627.10.camel@buesod1.americas.hpqcorp.net>
 <20140612203534.GA28328@kroah.com>
 <1402606118.2627.14.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402606118.2627.14.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 01:48:38PM -0700, Davidlohr Bueso wrote:
> On Thu, 2014-06-12 at 13:35 -0700, Greg Kroah-Hartman wrote:
> > On Thu, Jun 12, 2014 at 01:25:34PM -0700, Davidlohr Bueso wrote:
> > > On Thu, 2014-06-12 at 23:40 +0400, Wahib Faizi wrote:
> > > > Fix coding style issues detected by checkpatch.pl in usbip_host_driver.c.
> > > 
> > > Sorry but unless bundled with something more meaningful, I really don't
> > > see the value in these changes. I certainly don't want to discourage
> > > folks or anything, but just testing other patches is a lot more helpful
> > > than this. 
> > 
> > When the staging code is still needing basic fixes like this, it is
> > "meaningful" to do patches that clean up stuff like this.  That's what
> > the staging tree is for.
> 
> Sure, but "making checkpatch happy just to make checkpatch happy" isn't
> a good justification, even for staging.

It actually is.  Fighting against checkpatch is a losers battle.  Our
way more efficient.

1) We do need to fix this checkpatch warning before it moves out of
   staging.
2) NAKing patches is actually a lot of stress for everyone.  It stresses
   out submitters and drives them away.  It stresses out the
   maintainers because we feel bad.  That stress is bad when it is
   pointless.
3) This patch is ok.
4) If we don't apply this patch then someone else will send the exact
   same patch or something worse until we apply something.
5) The v3 of this patch takes under 30 seconds to review and apply.
6) Newbies feel happy when their patch gets merged and that is good.

The other thing is that if you start asking "Is this patch meaningful"
then it makes applying any patch into a big question about meaning and
it tires you out.

In staging we have clear rules for when a patch is going to be applied
and everyone understands the rules.  It means that if Greg is traveling
then you know which patches he is going to apply in what order and life
is easier because it is more predictable.

regards,
dan carpenter

