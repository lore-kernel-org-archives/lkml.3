Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaDQOyZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:54:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48193 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDQOyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:54:12 -0400
Date: Thu, 17 Apr 2014 15:53:24 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Alexander Shiyan <shc_work@mail.ru>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Thomas Schnuerer <thomas.schnuerer@men.de>
Subject: Re: [PATCH v2] tty: serial: Add driver for MEN's 16z135 High Speed
 UART.
Message-ID: <20140417155324.6fe03e8c@alan.etchedpixels.co.uk>
In-Reply-To: <1397742478-2894-1-git-send-email-johannes.thumshirn@men.de>
References: <1397742478-2894-1-git-send-email-johannes.thumshirn@men.de>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 15:47:58 +0200
Johannes Thumshirn <johannes.thumshirn@men.de> wrote:

> Add driver for MEN's 16z135 High Speed UART.
> 
> The 16z135 is a memory mapped UART Core on an MCB FPGA and has 1024 byte
> deep FIFO buffers for the RX and TX path. It also has configurable FIFO
> fill level IRQs and data copied to and from the hardware has to be
> acknowledged.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>

Reviewed-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>

Alan
