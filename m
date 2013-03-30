Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757589Ab3C3Bg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 21:36:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:35102 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757529Ab3C3Bg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 21:36:26 -0400
Date: Fri, 29 Mar 2013 21:36:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Geoff Levand <geoff@infradead.org>
cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Stephen Warren <swarren@nvidia.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>,
        USB list <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH v3 4/7] USB: EHCI: export ehci_shutdown
In-Reply-To: <1364603383.16937.60.camel@smoke>
Message-ID: <Pine.LNX.4.44L0.1303292135300.26395-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Mar 2013, Geoff Levand wrote:

> Hi Alan,
> 
> > Actually, I think this is not necessary.  Instead those three glue
> > files ought to be changed.  They should not need to call
> > ehci_shutdown() directly.
> 
> I sent out a separate patch that removes the ehci_shutdown()
> call in ps3_ehci_remove().  I tested it by removing and
> installing the ehci_hcd module and it seems to work OK.

Thanks!  I'll send it on up.

Alan Stern

