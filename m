Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab3EVWcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:32:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42373 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757889Ab3EVWck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:32:40 -0400
Date: Wed, 22 May 2013 15:32:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jay Vosburgh <fubar@us.ibm.com>
Cc: f.wiessner@smart-weblications.de, davem@davemloft.net,
        liquidhorse@gmail.com, andy@greyhouse.net,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
Message-ID: <20130522223239.GA26297@kroah.com>
References: <519CADA9.9060909@smart-weblications.de>
 <20130522135745.GA14640@kroah.com>
 <519CEF4B.5090108@smart-weblications.de>
 <20130522162336.GA5761@kroah.com>
 <519D0B79.6010307@smart-weblications.de>
 <20130522190640.GA20276@kroah.com>
 <519D1DEF.8090206@smart-weblications.de>
 <20130522200439.GA21367@kroah.com>
 <519D37F4.2030202@smart-weblications.de>
 <2972.1369259697@death.nxdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2972.1369259697@death.nxdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 02:54:57PM -0700, Jay Vosburgh wrote:
> Smart Weblications GmbH - Florian Wiessner wrote:
> 
> >Am 22.05.2013 22:04, schrieb Greg KH:
> >
> >
> >>>
> >>> https://kernel.googlesource.com/pub/scm/linux/kernel/git/jkirsher/net-next/+/567b871e503316b0927e54a3d7c86d50b722d955%5E!/
> >> 
> >> Ok, that's what we need.
> >> 
> >> Now, please cc: the developers / maintainers of that patch and ask them
> >> to have it included in the 3.4-stable kernel series.
> >> 
> >> Then, if they agree, the network maintainer will pick it up and send it
> >> to me for inclusion.
> >> 
> >
> >i set committer	David S. Miller <davem@davemloft.net> in cc already, but do not
> >know the network maintainer...
> >
> >this seems to me that "Matthew O'Connor" <liquidhorse@gmail.com> sent this to
> >netdev on 2013-02-01:
> >
> >http://lists.openwall.net/netdev/2013/02/01/86
> >
> >but i couldn't find a trace of the patch in 3.4.36?!
> 
> 	The patch in question here is in net-next; the commit is:
> 
> commit 567b871e503316b0927e54a3d7c86d50b722d955
> Author: zheng.li <zheng.x.li@oracle.com>
> Date:   Tue Nov 27 23:57:04 2012 +0000
> 
>     bonding: rlb mode of bond should not alter ARP originating via bridge
> 
> 
> 	The additional change in the backport from Matthew O'Connor (to
> add ether_addr_equal_64bits) appears to still be necessary for 3.4.46.
> Alternatively, the patch could utilize ether_addr_equal instead, to
> minimize the change set.  Greg, do you have a preference there?

What ever matches upstream is best.

> 	Submissions for stable from networking normally go through
> Davem; I can check the patch and repost it to netdev against 3.4.46 if
> everybody is ok with that.

Yes, I need networking stable patches to come to me from David.

thanks,

greg k-h
