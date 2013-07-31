Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab3GaMch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 08:32:37 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:60786 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751310Ab3GaMcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 08:32:35 -0400
X-Sasl-enc: pe5XCnTUu3rV5yt22g7o6xbHPSKVThCNzYqASct4TYVD 1375273954
Date: Wed, 31 Jul 2013 05:33:51 -0700
From: Greg KH <greg@kroah.com>
To: Tony Lindgren <tony@atomide.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] [ARM ATTEND] kernel data bloat
 and how to avoid it
Message-ID: <20130731123351.GA30474@kroah.com>
References: <20130731073802.GT7656@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130731073802.GT7656@atomide.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 12:38:03AM -0700, Tony Lindgren wrote:
> Hi all,
> 
> Probably the biggest kernel data bloat issue is in the ARM land, but
> it also seems that it's becoming a Linux generic issue too, so I
> guess it could be discussed in either context.

Why is it specific to ARM?  What is so unique to ARM that causes it to
"bloat"?

And what exactly do you mean by "bloat"?

> Basically the data bloat issue is there for the arch code and drivers
> and may not show up initially until things have headed the wrong way for
> too long.

What do you mean by this?  You seem to be very vague here.

greg k-h
