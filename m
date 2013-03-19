Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757595Ab3CSUKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:10:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56378 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751726Ab3CSUKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:10:10 -0400
Date: Tue, 19 Mar 2013 16:10:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sven Joachim <svenjoac@gmx.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI
 controllers
In-Reply-To: <87ehfbjkmn.fsf@turtle.gmx.de>
Message-ID: <Pine.LNX.4.44L0.1303191607390.1302-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Mar 2013, Sven Joachim wrote:

> > In what way is resume broken?
> 
> The kernel comes back, but the screen is black.  Manually switching VT's
> is possible, and if I type something I can see it on the screen, but
> there is no response and the cursor does not blink.  It looks as if the
> VT is not switched backed on resume, and userspace tasks are not
> restarted.  Sysrq combinations apparently work, but produce no output.

Are there any other problems?  For example, even before you do a 
suspend, if you type Alt-SysRq-W do you see any processes listed?

There was another report on the linux-usb mailing list today of this
same patch causing the khubd task to hang.  I'm thinking that you might
be facing a similar problem.

Alan Stern

