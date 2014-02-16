Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbaBPULR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 15:11:17 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:62661 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbaBPULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 15:11:16 -0500
Message-ID: <1392581469.28866.70.camel@x220>
Subject: Re: [PATCH 1/2] usb: host: remove USB_ARCH_HAS_?HCI
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Richard Weinberger <richard@nod.at>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 21:11:09 +0100
In-Reply-To: <Pine.LNX.4.44L0.1402161459290.11044-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1402161459290.11044-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 20:11:14.0733 (UTC) FILETIME=[3E7775D0:01CF2B53]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-16 at 15:02 -0500, Alan Stern wrote:
> On Sun, 16 Feb 2014, Paul Bolle wrote:
> > Note that the comment in this Kconfig file (that is also removed)
> > suggests to first remove the select statements for these symbols and
> > then the symbols themselves. But I think it makes more sense to first
> > delete these three symbols and then remove the selects statements (as
> > that is removing a second order effect). But it could just as well be
> > done with just one patch, I'd say.
> 
> There's a simple reason for not getting rid of the symbols first.  
> Doing it that way, as you did, leaves a window in which it's possible
> to select a non-existent symbol.  If that's not an error, it ought to
> be.

It is silently ignored. I've contemplated diving in the kconfig code to
see whether doing that could be made to trigger an error or, perhaps
better, a warning. I've not made up my mind yet.

It's trivial to merge these two patches, though. So feel free to ask me
to do that.

> Regardless, for both patches:
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

Thanks.


Paul Bolle


