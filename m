Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934282AbaE2Onn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:43:43 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45478 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423AbaE2Onm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:43:42 -0400
Date: Thu, 29 May 2014 15:42:17 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lugovskoy@dev.rtsoft.ru
Subject: Re: [PATCH] usb: pci-quirks: do not access OHCI_FMINTERVAL register
 on ULI hw
Message-ID: <20140529154217.6248ae95@alan.etchedpixels.co.uk>
In-Reply-To: <5387450C.7030207@dev.rtsoft.ru>
References: <Pine.LNX.4.44L0.1405281014320.1552-100000@iolanthe.rowland.org>
	<5386C6F9.7070202@dev.rtsoft.ru>
	<5387450C.7030207@dev.rtsoft.ru>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know how linux usb subsystem should behave against such
> "half-existing" hardware. Perhaps hanging is not the best idea...
> but maybe it should be fixed elsewhere, e.g. by masking non-wired
> devices in platform PCI setup. Perhaps controlled by some device-tree
> key.

Does it have a unique svid/sdid set for the platform - if so you could
just blacklist that combination of vid/did/svid/sdid.

Alan
