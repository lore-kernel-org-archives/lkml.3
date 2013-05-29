Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934547Ab3E2BPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:15:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34976 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3E2BO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:14:59 -0400
Date: Wed, 29 May 2013 10:15:22 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
Cc: "Matthew O'Connor" <matt@ecsorl.com>, davem@davemloft.net,
        andy@greyhouse.net, fubar@us.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        nikolay@redhat.com, vfalico@redhat.com, zheng.x.li@oracle.com,
        liquidhorse@gmail.com
Subject: Re: https://lkml.org/lkml/2013/2/1/531
Message-ID: <20130529011522.GA5653@kroah.com>
References: <20130522162336.GA5761@kroah.com>
 <519D0B79.6010307@smart-weblications.de>
 <20130522190640.GA20276@kroah.com>
 <519D1DEF.8090206@smart-weblications.de>
 <20130522200439.GA21367@kroah.com>
 <519D37F4.2030202@smart-weblications.de>
 <519D5206.8080701@gmail.com>
 <519DEE6E.7060700@smart-weblications.de>
 <519E0F97.1050102@ecsorl.com>
 <51A55381.9080807@smart-weblications.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51A55381.9080807@smart-weblications.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 03:01:53AM +0200, Smart Weblications GmbH - Florian Wiessner wrote:
> Am 23.05.2013 14:46, schrieb Matthew O'Connor:
> > On 05/23/2013 06:24 AM, Smart Weblications GmbH - Florian Wiessner wrote:
> >> node02:/ocfs2/usr/src/linux-3.4.46# cat drivers/net/bonding/bond_alb.c.rej
> > My most sincere apologies - one more time, from a different mail server
> > that hopefully won't go around changing my attachments.  If this doesn't
> > work I guess sendmail will be the next alternative.
> > 
> 
> 3.4.47 got released without that included :-/?!
> 
> https://www.kernel.org/pub/linux/kernel/v3.x/ChangeLog-3.4.47

Yes, it missed that last release, I'll get a new one out when I get back
from Japan next week.

thanks,

greg k-h
