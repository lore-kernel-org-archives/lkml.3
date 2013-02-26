Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab3BZSvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 13:51:10 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:4115 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752761Ab3BZSvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 13:51:08 -0500
Date: Tue, 26 Feb 2013 19:50:59 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problem with commit "USB: EHCI: remove ASS/PSS polling timeout"
Message-ID: <20130226195059.7f763ca5@endymion.delvare>
In-Reply-To: <Pine.LNX.4.44L0.1302261316450.1832-100000@iolanthe.rowland.org>
References: <20130226182409.046bdecd@endymion.delvare>
	<Pine.LNX.4.44L0.1302261316450.1832-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Tue, 26 Feb 2013 13:21:30 -0500 (EST), Alan Stern wrote:
> On Tue, 26 Feb 2013, Jean Delvare wrote:
> > Since kernel 3.7.7, my Hauppauge Nova-T 500 Dual DVB-T TV card stopped
> > working reliably. Half of the boots it will work, the other half it
> > won't, with different error messages. For example
> 
> Yes, I know.  Other people have already reported the same problem -- 
> but only for EHCI controllers made by VIA.  Do you also have a VIA EHCI 
> controller?

Yes, VIA VT6212L:

01:04.0 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 62)
01:04.1 USB Controller [0c03]: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1 Controller [1106:3038] (rev 62)
01:04.2 USB Controller [0c03]: VIA Technologies, Inc. USB 2.0 [1106:3104] (rev 65)

> > So please revert this commit upstream as well as in 3.8 and 3.7 stable
> > kernel series.
> 
> I intend to as soon as the current merge window closes.
> 
> Or should I do it sooner?  Greg, if I send in a reversion patch now, 
> will it get pushed to Linus within the merge window?

I see no reason to delay it. The merge window is when more patches are
allowed to go in, not fewer. When a commit caused a regression in a
stable kernel series, the right time to get it fixed is "as soon as
possible."

Thanks,
-- 
Jean Delvare
