Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933869Ab3CSU2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:28:37 -0400
Received: from mout.gmx.net ([212.227.15.18]:49452 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296Ab3CSU2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:28:34 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX19TBShhxEVT7Z1YtMow9ehWWRJSPHsRQSyLxE27FT
	uESW3bD7Lbb62D
From: Sven Joachim <svenjoac@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Stephen Thirlwall <sdt@dr.com>
Subject: Re: [ 12/75] USB: EHCI: work around silicon bug in Intels EHCI controllers
References: <Pine.LNX.4.44L0.1303191607390.1302-100000@iolanthe.rowland.org>
Date: Tue, 19 Mar 2013 21:28:29 +0100
In-Reply-To: <Pine.LNX.4.44L0.1303191607390.1302-100000@iolanthe.rowland.org>
	(Alan Stern's message of "Tue, 19 Mar 2013 16:10:09 -0400 (EDT)")
Message-ID: <87620n9lsi.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-19 21:10 +0100, Alan Stern wrote:

> On Tue, 19 Mar 2013, Sven Joachim wrote:
>
>> > In what way is resume broken?
>> 
>> The kernel comes back, but the screen is black.  Manually switching VT's
>> is possible, and if I type something I can see it on the screen, but
>> there is no response and the cursor does not blink.  It looks as if the
>> VT is not switched backed on resume, and userspace tasks are not
>> restarted.  Sysrq combinations apparently work, but produce no output.
>
> Are there any other problems?  For example, even before you do a 
> suspend, if you type Alt-SysRq-W do you see any processes listed?

No.

> There was another report on the linux-usb mailing list today of this
> same patch causing the khubd task to hang.  I'm thinking that you might
> be facing a similar problem.

Maybe, but before the suspend everything seems to be normal.

Cheers,
       Sven
