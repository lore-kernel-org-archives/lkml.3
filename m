Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448AbaBCShj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 13:37:39 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:50021 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753252AbaBCShh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 13:37:37 -0500
Message-ID: <1391452654.2307.4.camel@x220>
Subject: Re: [PATCH] usb: phy: Quiet unable to find transceiver message
From: Paul Bolle <pebolle@tiscali.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: balbi@ti.com, Josh Boyer <jwboyer@fedoraproject.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        valentine.barshak@cogentembedded.com
Date: Mon, 03 Feb 2014 19:37:34 +0100
In-Reply-To: <Pine.LNX.4.44L0.1402031102440.1410-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1402031102440.1410-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2014 18:37:35.0331 (UTC) FILETIME=[01AC0330:01CF210F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-03 at 11:04 -0500, Alan Stern wrote:
> On Mon, 3 Feb 2014, Paul Bolle wrote:
> > This message cab still be seen when booting v3.14-rc1. Is a patch to
> > downgrade this message to dev_dbg() - from Josh, Felipe or someone else
> > - queued somewhere?
> 
> 	http://marc.info/?l=linux-usb&m=139092084714232&w=2
> 
> As far as I know, this hasn't been merged into anybody's tree yet.  And 
> Felipe is on vacation for a few weeks.  Still, it should get in before 
> 3.14 is released.

Thanks.

I'll add it to my local stack of patches, and if nothing is merged in a
few weeks I might send a short reminder.


Paul Bolle


