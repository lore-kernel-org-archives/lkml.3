Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaGBJGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:06:00 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:52539 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbaGBJF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:05:58 -0400
Message-ID: <1404291956.12021.23.camel@x220>
Subject: Re: [PATCH] USB: remove CONFIG_USB_PERSIST from Documentation
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-usb@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 02 Jul 2014 11:05:56 +0200
In-Reply-To: <Pine.LNX.4.44L0.1406241317200.888-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1406241317200.888-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Jul 2014 09:05:56.0604 (UTC) FILETIME=[D5965BC0:01CF95D4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-24 at 13:19 -0400, Alan Stern wrote:
> On Tue, 24 Jun 2014, Paul Bolle wrote:
> > On Tue, 2014-06-24 at 10:25 -0400, Alan Stern wrote:
> > > Also, that "Later kernels" thing has already arrived.  I believe it was 
> > > implemented in 2.6.35.
> > 
> > How does the kernel currently call the disconnect method? I can't yet
> > say for sure, and it seems silly to send a v2 dropping those lines
> > without actually knowing why they can be dropped.
> 
> In drivers/usb/core/driver.c:usb_resume_complete(), which is called 
> during the final "complete" phase of system suspend, interfaces that 
> were marked for rebinding (because their drivers didn't have proper PM 
> support) get rebound.
> 
> Is that what you wanted to know?

I haven't yet discovered what the link is between rebinding and the
"disconnect" method. I'll have to study that. This is far from urgent,
so that might take me quite some time.

Thanks anyway,


Paul Bolle

