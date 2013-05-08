Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3EHQXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:23:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58412 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717Ab3EHQXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:23:53 -0400
X-Sasl-enc: B5SGg7007ROYPPsMJqyLRqACXHNEeofq2KvkI+d1TXHf 1368030231
Date: Wed, 8 May 2013 09:23:50 -0700
From: Greg KH <gregkh@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Dan Williams <dcbw@redhat.com>,
        "'George0505'" <george0505@realtek.com>,
        Joon Ro <joonhyoung.ro@gmail.com>
Subject: Re: Linux driver for Realtek RTL8723AU devices with USB ID 0bda:1724
 such as found in Lenovo IdeaPad Yoga 13
Message-ID: <20130508162350.GC28080@kroah.com>
References: <5159B52D.3050601@lwfinger.net>
 <5189B939.4010905@zytor.com>
 <518A7814.1070604@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518A7814.1070604@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 11:06:44AM -0500, Larry Finger wrote:
> On 05/07/2013 09:32 PM, H. Peter Anvin wrote:
> >
> >So I can verify that this driver works against 3.8.11 (not against
> >current -linus because of a build failure), and yes, there is Bluetooth
> >in this device.  In fact, it seems to work better than some in-tree
> >drivers I have seen in the past.
> >
> >However, I'm confused as to the above and what it implies for the
> >purpose of the staging tree.  Wasn't the whole point of the staging tree
> >to have a working-but-ugly driver upstream and have the work to clean it
> >up happen in the mainline tree instead of off somewhere.
> 
> Yes, but even staging has some standards.

I have standards?  That's a first :)

> For example, they frown on inclusion of firmware in a massive data
> block in a file in the driver - it should be in a separate file the
> /lib/firmware/ tree.

Sure, that would be "nice", but it's not something that I should reject
a driver for, have I done that?

> In addition, the mainline drivers/net/wireless/ tree is only available
> to devices that use mac80211 for the software-based MAC layer. That
> conversion is a serious effort that may never be done, thus the
> 8723au driver may never leave staging.

That's a bigger deal, but note, some drivers have done it, it is not
impossible.

thanks,

greg k-h
