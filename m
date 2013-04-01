Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822Ab3DAP3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:29:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35903 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758505Ab3DAP3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:29:35 -0400
Date: Mon, 1 Apr 2013 11:29:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 7/7] USB: OHCI: avoid conflicting platform drivers
In-Reply-To: <201303301256.19027.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1304011128110.1036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Mar 2013, Arnd Bergmann wrote:

> > I guess this means the onus is now on me to split up ohci-hcd into a 
> > central library and separate bus drivers, like ehci-hcd...
> 
> The original plan in my teams was that Manjunath would do that after
> he was done with the simple conversion of the EHCI drivers. I think we
> can all agree now that it's better if you at least the groundwork instead.

Yes, it would be better for me to prepare for the general split-up.

> Please let us know if you would like Manjunath to continue with splitting
> out the OHCI back-ends into separate drivers, or if you think that there
> is no point given the quality of the earlier patches.

This is how people learn.  After I have taken care of the initial steps 
and converted a couple of the drivers, Manjunath can work on the rest.

Alan Stern

