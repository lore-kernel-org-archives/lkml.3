Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaBGP0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 10:26:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56773 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaBGP0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 10:26:37 -0500
Date: Fri, 7 Feb 2014 07:28:28 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Zoran Markovic <zoran.markovic@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>,
        Julius Werner <jwerner@chromium.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Matthias Beyer <mail@beyermatthias.de>,
        Dan Williams <dan.j.williams@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>
Subject: Re: [RFC PATCHv2] usb: move hub init and LED blink work to power
 efficient workqueue
Message-ID: <20140207152828.GA11557@kroah.com>
References: <CAME+o4nK+hOs+TygwzVzDBTUMfF7dWs9WVg2FTMSt6neYckVtA@mail.gmail.com>
 <Pine.LNX.4.44L0.1402071018400.1326-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1402071018400.1326-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 10:20:57AM -0500, Alan Stern wrote:
> Please don't top-post.
> 
> On Fri, 7 Feb 2014, Zoran Markovic wrote:
> 
> > I believe there may still be use cases where you want to wake up the
> > same CPU that scheduled the work.
> 
> Won't the majority of cases not care which CPU is used?  Therefore,
> shouldn't the default behavior be to use the power-efficient work
> queue?
> 
> > Thanks for the Ack. Can you please queue this for 3.14?
> 
> That's up to Greg KH.  He may decide it's not important enough to go 
> into 3.14, and delay it until 3.15.

It's 3.15 material, as it doesn't fix a regression at this point in
time.

I'll queue it up when I get to it in a week or so, thanks.

greg k-h
