Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab3DYPpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 11:45:00 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39196 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758442Ab3DYPo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 11:44:59 -0400
Date: Thu, 25 Apr 2013 11:44:58 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sedat Dilek <sedat.dilek@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for Apr 24 [ PM: Device 1-1.2 failed to resume
 async: error -32 ]
In-Reply-To: <CA+icZUVBbFPYXQRG6C7RN00NPXqwsq7Jy=Gj8udA97utiCd=ZA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1304251135540.948-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Apr 2013, Sedat Dilek wrote:

> With CONFIG_USB_DEBUG=y I do not see a PM/async line.
> 
> Might you have a look at the logs?

They look quite normal.  Except for one thing: The built-in hubs appear 
to have gotten reset during the suspend/resume, for no apparent reason.  
That's probably the reason why the Logitech mouse needed a reset.

I don't know why the mouse reset worked this time but not before,
unless it's a subtle timing issue (the extra debugging output causes
the resume to go a little more slowly).

Alan Stern

