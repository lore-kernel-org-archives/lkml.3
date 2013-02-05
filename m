Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab3BEQgt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:36:49 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:56691 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751437Ab3BEQgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:36:48 -0500
Date: Tue, 5 Feb 2013 11:36:47 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        <pkondeti@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay
 region during unlink
In-Reply-To: <51112B02.80507@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1302051135580.2245-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Joseph Salisbury wrote:

> > I have replied to the original report at bugs.launchpad.net with a
> > diagnostic patch.  Maybe it will help indicate what's going wrong.
> >
> > Alan Stern
> >
> Thanks so much for the assistance, Alan.  I'll work with the bug 
> reporter to build a kernel with the patch and test.

The bug reporter may not need any help, considering that he was already 
able to carry out a git bisection search.

Alan Stern

