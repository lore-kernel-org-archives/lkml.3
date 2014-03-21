Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965600AbaCUNXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:23:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45118 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965502AbaCUNXb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:23:31 -0400
Date: Fri, 21 Mar 2014 13:22:37 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: jon@ringle.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        shc_work@mail.ru, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, devicetree@vger.kernel.org,
        Jon Ringle <jringle@gridpoint.com>
Subject: Re: [PATCH v2] tty: serial: sc16is7xx
Message-ID: <20140321132237.7aebefcf@alan.etchedpixels.co.uk>
In-Reply-To: <20140321082609.GA3801@xps8300>
References: <1395324333-21221-1-git-send-email-jon@ringle.org>
	<20140321082609.GA3801@xps8300>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 10:26:09 +0200
Heikki Krogerus <heikki.krogerus@linux.intel.com> wrote:

> Hi,
> 
> On Thu, Mar 20, 2014 at 10:05:33AM -0400, jon@ringle.org wrote:
> > From: Jon Ringle <jringle@gridpoint.com>
> > 
> > The SC16IS7xx is a slave I2C-bus/SPI interface to a single-channel
> > high performance UART. The SC16IS7xx’s internal register set is
> > backward-compatible with the widely used and widely popular 16C450.
> 
> So couldn't this be just a probe driver for 8250?

That was my first thought but if you look at 8250 and its locking
assumptions it is a very poor fit. Better for now it is separate I think.

Alan
