Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934929AbaH0O5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:57:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53159 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934883AbaH0O5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:57:37 -0400
Date: Wed, 27 Aug 2014 10:57:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Douglas Gilbert <dgilbert@interlog.com>
cc: Matthieu CASTET <matthieu.castet@parrot.com>, <linux-scsi@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Buffer I/O error after s2ram with usb storage
In-Reply-To: <53FDE5FD.8080607@interlog.com>
Message-ID: <Pine.LNX.4.44L0.1408271054560.1460-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Douglas Gilbert wrote:

> The unit attention doesn't look like a problem, it
> looks correct. If the system is unable to detect
> removable media being changed while the system is
> suspended, then ....
> 
> If the media has a unique identifier, then this unit
> attention at wakeup should trigger sd to make sure
> that unique identifier has not changed.

Does sd have any code to do this?  I'm not aware of any, but there 
ought to be some.  Otherwise there's no way to tell when a so-called 
media change was just the old media being taken out and put back in.

Or maybe this functionality belongs in the block layer rather than in 
sd.

Alan Stern

