Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbaFXRRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 13:17:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45468 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755284AbaFXRRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 13:17:19 -0400
Date: Tue, 24 Jun 2014 13:17:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Paul Bolle <pebolle@tiscali.nl>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-api@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation: sysfs-bus-usb: update power/persist
 description
In-Reply-To: <1403628854.1960.21.camel@x220>
Message-ID: <Pine.LNX.4.44L0.1406241316550.888-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jun 2014, Paul Bolle wrote:

> On Tue, 2014-06-24 at 10:15 -0400, Alan Stern wrote:
> > The default value for the persist facility depends on the setting of 
> > CONFIG_USB_DEFAULT_PERSIST.  If that symbol is set then persist is 
> > enabled by default for all devices, except those which have the 
> > USB_QUIRK_RESET flag set (meaning that they will morph or change modes 
> > when reset).  If the symbol is not set then persist is enabled by 
> > default only for hubs.
> > 
> > Thanks for the documentation update.
> 
> You do expect a v2 updated to reflect your comments, don't you?

It would be nice.

Alan Stern

