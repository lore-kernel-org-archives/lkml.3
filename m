Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759679Ab3BZSVd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:21:33 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39977 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753124Ab3BZSVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:21:31 -0500
Date: Tue, 26 Feb 2013 13:21:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jean Delvare <khali@linux-fr.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with commit "USB: EHCI: remove ASS/PSS polling timeout"
In-Reply-To: <20130226182409.046bdecd@endymion.delvare>
Message-ID: <Pine.LNX.4.44L0.1302261316450.1832-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013, Jean Delvare wrote:

> Hi Alan, Greg,
> 
> Since kernel 3.7.7, my Hauppauge Nova-T 500 Dual DVB-T TV card stopped
> working reliably. Half of the boots it will work, the other half it
> won't, with different error messages. For example

Yes, I know.  Other people have already reported the same problem -- 
but only for EHCI controllers made by VIA.  Do you also have a VIA EHCI 
controller?

> So please revert this commit upstream as well as in 3.8 and 3.7 stable
> kernel series.

I intend to as soon as the current merge window closes.

Or should I do it sooner?  Greg, if I send in a reversion patch now, 
will it get pushed to Linus within the merge window?

> As a side note, I am very curious how a commit with comment "I don't
> know if this will actually fix anything" ever made it into a stable
> kernel tree. I thought there were stable kernel tree rules and one of
> them was "it must fix a real bug that bothers people"?

Somebody reported a problem, and I wrote a series of two patches to fix
it.  With the two patches together the problem went away, but we never
tried to figure out whether either one of them would have sufficed.  I
simply submitted both patches.

Alan Stern

