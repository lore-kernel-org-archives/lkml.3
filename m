Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899AbaJWLS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:18:29 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:38941 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753944AbaJWLS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:18:28 -0400
Date: Thu, 23 Oct 2014 12:18:15 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: russ.dill@gmail.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R
 devices
Message-ID: <20141023121815.1d8ef21d@alan.etchedpixels.co.uk>
In-Reply-To: <20141023094053.GA30334@kroah.com>
References: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
	<20141023094053.GA30334@kroah.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  drivers/usb/serial/ftdi_sio.c | 111 +++++++++++++++++++++++++++++++++++++++++-
> >  drivers/usb/serial/ftdi_sio.h |  41 ++++++++++++++++
> >  2 files changed, 151 insertions(+), 1 deletion(-)
> 
> Funny patch, you should have saved it for April 1, otherwise people
> might have actually taken this seriously :)
> 
> Patches as performance art, now I've seen everything...

Chuckle. Sillyness aside a pure detection version of that patch might be
useful so it can warn users "Running Windows may damage your adapter" 8)

Is the 0x0000, 0x0401 they end up with consistent - can we add that to the
default table so end users can at least make use of devices that have
been attacked by malware ?

Alan
