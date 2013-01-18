Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab3ARU31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 15:29:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41973 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751119Ab3ARU3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 15:29:25 -0500
Date: Fri, 18 Jan 2013 15:29:23 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Miller <davem@davemloft.net>
cc: freddy@asix.com.tw, <netdev@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <louis@asix.com.tw>
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
In-Reply-To: <20130118.142316.708739494707619536.davem@davemloft.net>
Message-ID: <Pine.LNX.4.44L0.1301181524110.1190-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jan 2013, David Miller wrote:

> > +	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR |
> > +			USB_RECIP_DEVICE, value, index, data, size);
> 
> This is not indented properly.  When a function call takes up
> multiple lines, the text on the second and subsequent lines must
> be left justified to the first column after the openning parenthesis
> of the function call, like this:
> 
> 	function(arg1, arg2,
> 		 arg3, arg4);
> 
> You must use the appropriate combination of TAB and space characters
> to achieve this.  If you are trying to only use TAB characters, you
> are doing it wrong.

Documentation/CodingStyle doesn't mention this.  Does the networking 
stack have its own special requirements, not listed in CodingStyle?

Alan Stern

P.S: The standard I have tried to follow for USB code is to indent
continuation lines by two tab stops more than the first line,
regardless of whether the break occurs inside a function call.  I have
seen other people consistently indent continuation lines by 1/2 tab
stop (i.e., four spaces) beyond the first line.

