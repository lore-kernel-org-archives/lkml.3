Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932657Ab3LDPVy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:21:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:50838 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932545Ab3LDPVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:21:52 -0500
Date: Wed, 4 Dec 2013 10:21:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: boris brezillon <b.brezillon@overkiz.com>
cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
In-Reply-To: <529EE8A5.7010806@overkiz.com>
Message-ID: <Pine.LNX.4.44L0.1312041021120.1329-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Dec 2013, boris brezillon wrote:

> > The patches look fine to me.  But only the 1/3 patch fixes a bug; the
> > others merely change the resource management.
> 
> Do you want me to split this series ?
>   1) the 1st patch that should be merged in 3.13
>   2) patches 2 to 4 that might be applied later

That probably would make Greg happier.

Alan Stern

