Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762132Ab3DBSVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 14:21:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54628 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760520Ab3DBSVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 14:21:43 -0400
Date: Tue, 2 Apr 2013 14:21:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-kernel@vger.kernel.org, <arnd@arndb.de>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 2/5 v2] USB: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO}
 depends on architecture symbol
In-Reply-To: <1364922626-32407-3-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1304021419390.1314-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Florian Fainelli wrote:

> Just like the OHCI counter part we just can remove the architecture
> specific symbols which prevent these configuration symbols from being
> selected by platforms/architectures requiring it. The original
> implementation did not scale at all since it required each and every
> single architecture to be added for these configuration symbols to be
> selected. Now it is up to the EHCI driver and/or platform to select
> these configuration symbols accordingly.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

