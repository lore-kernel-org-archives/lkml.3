Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3BDWEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 17:04:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:33202 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754954Ab3BDWEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 17:04:30 -0500
Date: Mon, 4 Feb 2013 17:04:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Joseph Salisbury <joseph.salisbury@canonical.com>
cc: Ben Hutchings <ben@decadent.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        <pkondeti@codeaurora.org>, Greg KH <gregkh@linuxfoundation.org>,
        Herton Krzesinski <herton.krzesinski@canonical.com>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [REVERT][v3.x.y] EHCI: Update qTD next pointer in QH overlay
 region during unlink
In-Reply-To: <510C4700.5030304@canonical.com>
Message-ID: <Pine.LNX.4.44L0.1302041702590.1756-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Feb 2013, Joseph Salisbury wrote:

> Hi Alan,
> 
> There is a tar file[0] attached to the bug report[1].  The tar file 
> contains a few examples of failed and successful recording attempts 
> while collecting usbmon traces.  There is a readme.txt file available 
> after extracting the files.
> 
> The bug reporter states that only the first recording after boot fails. 
> Subsequent recordings succeed will succeed.
> 
> Thanks again for reviewing this, Alan.  Just let me know if you would 
> like any additional data or testing.
> 
> Thanks,
> 
> Joe
> 
> [0] 
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1088733/+attachment/3510887/+files/usbmon-1088733.tar.gz
> [1] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1088733

I have replied to the original report at bugs.launchpad.net with a
diagnostic patch.  Maybe it will help indicate what's going wrong.

Alan Stern

