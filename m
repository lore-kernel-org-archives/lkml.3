Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759975Ab3GZV4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:56:38 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35019 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757248Ab3GZV4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:56:36 -0400
X-Sasl-enc: jl49FwavZSFgFS13AWaW96jCvZ/yQf6O1IU3yiHWJfVd 1374875795
Date: Fri, 26 Jul 2013 14:56:34 -0700
From: Greg KH <greg@kroah.com>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the staging tree
Message-ID: <20130726215634.GA31820@kroah.com>
References: <20130726160254.83bbe994219d6ee732c64b7d@canb.auug.org.au>
 <20130726210335.GA2788@kroah.com>
 <51F2E8A4.2010405@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F2E8A4.2010405@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 27, 2013 at 12:22:44AM +0300, Eli Billauer wrote:
> Hello Greg,
> 
> I was just about to submit a patch fixing this issue. Should arrive
> in a few minutes. Sorry.

Got it, thanks.

> Will this be the follow-on patch you mentioned for fixing the
> "sparse errors" this driver produced? I'm wasn't sure what you meant
> with that.

No, I need you to do that.  Can you do a kernel build with:
	make M=drivers/staging/xillybus C=1
and fix up the errors that sparse reports and send a patch for that?

thanks,

greg k-h
