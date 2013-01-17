Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab3AQS4n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 13:56:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33325 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755039Ab3AQS4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 13:56:41 -0500
Date: Thu, 17 Jan 2013 13:56:39 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        <pkondeti@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        <stable@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay
 region during unlink
In-Reply-To: <50F84441.8080300@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1301171353330.1339-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2013, Joseph Salisbury wrote:

> Hello,
> 
> Please consider reverting commit 
> 3d037774b42ed677f699b1dce7d548d55f4e4c2b in mainline as well as in the 
> current stable releases.  It was included upstream as of v3.6-rc6.  This 
> commit introduced a regression, described in the following bug report:
> 
> http://bugs.launchpad.net/bugs/1088733
> 
> Reverting commit 3d037774b42ed677f699b1dce7d548d55f4e4c2b in the v3.2 
> kernel has been confirmed to resolve the aforementioned bug.

I do not want to revert this commit without first understanding what is 
going wrong.  Please ask the reporter to post usbmon traces showing 
what happens in both a failed and a successful recording attempt.

Alan Stern

