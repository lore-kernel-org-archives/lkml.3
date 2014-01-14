Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794AbaANMIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 07:08:35 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50310 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbaANMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:08:32 -0500
Date: Tue, 14 Jan 2014 12:08:11 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Pavel Roskin <proski@gnu.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: serial8250: bogus low_latency destabilizes kernel, need sanity
 check
Message-ID: <20140114120811.648571ea@alan.etchedpixels.co.uk>
In-Reply-To: <20140113193547.47b7a646@IRBT4585>
References: <20140113193547.47b7a646@IRBT4585>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe we should unset the low_latency flag as soon as DMA fails?  There
> are two flags, one is state->uart_port->flags and the other is
> port->low_latency.  I guess we need to unset both.

Well low latency and DMA are pretty much exclusive in the real world so
probably DMA ports shouldn't allow low_latency to be set at all in DMA
mode.

Alan
