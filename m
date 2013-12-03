Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570Ab3LCPcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 10:32:41 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:60658 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753557Ab3LCPcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 10:32:35 -0500
Date: Tue, 3 Dec 2013 10:32:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: Boris BREZILLON <b.brezillon@overkiz.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/3] usb: ohci-at91: use device managed clk retrieval
In-Reply-To: <529DE791.6080007@atmel.com>
Message-ID: <Pine.LNX.4.44L0.1312031030390.1226-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, Nicolas Ferre wrote:

> On 03/12/2013 15:07, Boris BREZILLON :
> > Replace clk_get calls by devm_clk_get calls.
> >
> > Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> > Tested-by: Robert Nelson <robertcnelson@gmail.com>
> 
> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Thanks Boris for these fixes.
> 
> Alan, Greg, can you take the whole series as fixes for 3.13?

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

The patches look fine to me.  But only the 1/3 patch fixes a bug; the 
others merely change the resource management.

Alan Stern

