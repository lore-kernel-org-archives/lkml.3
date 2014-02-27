Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaB0JX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 04:23:27 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:43949 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaB0JXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:23:21 -0500
Date: Thu, 27 Feb 2014 09:22:23 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Feng Tang <feng.79.tang@gmail.com>
Cc: Peter Hurley <peter@hurleysoftware.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Beat Bolli <bbolli@ewanet.ch>, Pavel Roskin <proski@gnu.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, David Sterba <dsterba@suse.cz>,
        Felipe Balbi <balbi@ti.com>, Grant Edwards <grant.b.edwards@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Hal Murray <murray+fedora@ip-64-139-1-69.sjc.megapath.net>,
        stable@vger.kernel.org,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>, feng.tang@intel.com,
        bin.yang@intel.com, alek.du@intel.com
Subject: Re: [PATCH] tty: Fix low_latency BUG
Message-ID: <20140227092223.5b035f7f@alan.etchedpixels.co.uk>
In-Reply-To: <CA++bM2vjzFOt5wmc=TQ1XMvRCwgnpq6=PKpex=GGZBK_-M6=mw@mail.gmail.com>
References: <1393072281-5814-1-git-send-email-peter@hurleysoftware.com>
	<CA++bM2uq=vRo20FTMWvkDau+-X7h0+KU3n4Av7ef895mQKr5fA@mail.gmail.com>
	<530E0AD3.7040909@hurleysoftware.com>
	<CA++bM2vjzFOt5wmc=TQ1XMvRCwgnpq6=PKpex=GGZBK_-M6=mw@mail.gmail.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'm glad to hear that the Bluetooth uart interface is getting
> > some use; that means someone will soon be fixing the hard lockup
> > in hci_uart_tx_wakeup() reported here:
> 
> I'm not very familiar with the BT devices on our platforms, but most
> of them are not using the in-kernel BT driver, some just use the
> n_tty ldisc and the raw data, some use their own ldisc driver.

Outside of the world of phones/android the Bluetooth on quite a few of the
Baytrail/T devices is on the LPSS serial so it probably will be getting
tested sooner not later and there will actually be a common platform
around that is using the bluetooth uart features.

I'm not anticipating any problems though.

Alan
