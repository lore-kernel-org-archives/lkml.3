Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329AbbAUSwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:52:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35485 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753110AbbAUSwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:52:43 -0500
Date: Wed, 21 Jan 2015 13:52:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Olivier Sobrie <olivier@sobrie.be>
cc: Jan Dumon <j.dumon@option.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH 11/11] usb: core: fix a race with usb_queue_reset_device()
In-Reply-To: <20150121135512.GA9889@hposo>
Message-ID: <Pine.LNX.4.44L0.1501211351560.1670-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Olivier Sobrie wrote:

> I tested your patch. It also fixes the problem I observed.
> You can drop mine.
> 
> For your info:
> 
> My test consists in powering down a usb hso modem while one of its
> serial port is opened. It leads to two URB failures, each urb callback
> queues a reset.
> Without your fix (or without the one I sent), a crash happens after
> less than ~20 power up/down sequences. With your fix, after more than
> 1000 power up/down I don't see any crash.

Okay, I'll submit the patch.  Thanks for testing it.

Alan Stern

