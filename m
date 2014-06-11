Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaFKSyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 14:54:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42674 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753195AbaFKSyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 14:54:16 -0400
Date: Wed, 11 Jun 2014 14:54:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Himangi Saraogi <himangi774@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jan Andersson <jan@gaisler.com>, Andreas Larsson <andreas@gaisler.com>,
        <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3] usb: host: uhci-grlib.c : use devm_ functions
In-Reply-To: <20140611183823.GA10519@himangi-Dell>
Message-ID: <Pine.LNX.4.44L0.1406111453230.890-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2014, Himangi Saraogi wrote:

> The various devm_ functions allocate memory that is released when a
> driver detaches. This patch uses devm_ioremap_resource for data
> that is allocated in the probe function of a platform device and
> is only freed in the remove function. The corresponding free functions
> are removed and two labels are done away with. Also, linux/device.h
> is added to make sure the devm_*() routine declarations are
> unambiguously available.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> Not compile tested due to incompatible architecture.
> v3: pass correct arguments to devm_ioremap_resource

Acked-by: Alan Stern <stern@rowland.harvard.edu>

What happened to the corresponding patch for uhci-platform.c?

Alan Stern

