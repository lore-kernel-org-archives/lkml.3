Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab3DAP1Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 11:27:16 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35891 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751552Ab3DAP1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 11:27:14 -0400
Date: Mon, 1 Apr 2013 11:27:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Deepak Saxena <dsaxena@linaro.org>,
        Shiraz Hashim <shiraz.hashim@st.com>, <spear-devel@list.st.com>
Subject: Re: [PATCH v3 2/7] USB: EHCI: make ehci-spear a separate driver
In-Reply-To: <201303311830.11338.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.1304011126190.1036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Mar 2013, Arnd Bergmann wrote:

> On Saturday 30 March 2013, Arnd Bergmann wrote:
> > > > In V3:
> > > >  -Detailed commit message added here about why this patch is required.
> > > >  -Eliminated ehci_spear_setup routine beacuse hcd registers
> > > >   directly setting in spear_ehci_hcd_drv_probe function.
> > > 
> > > Fix the grammar, please.
> > 
> > Done. I agree some of this is hardly legible.
> > 
> 
> I realized later that the other patches have similarly screwed up
> changelogs. I'll send a new version once you've commented on v4,
> so in case there is anything else I missed I'm not spamming everyone
> another time.

I still haven't checked the details of the last patch in the series 
(the OHCI changes).  However, for patches 1/6 - 5/6:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

