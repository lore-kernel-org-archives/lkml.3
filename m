Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbaBXXnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 18:43:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54188 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733AbaBXXms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 18:42:48 -0500
Date: Mon, 24 Feb 2014 18:42:47 -0500
From: Kyle McMartin <kyle@infradead.org>
To: Keith Packard <keithp@keithp.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] net/usb: Add Lenovo ThinkPad OneLink GigaLAN USB ID to
 ax88179 driver
Message-ID: <20140224234247.GB14970@merlin.infradead.org>
References: <1393283629-25396-1-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393283629-25396-1-git-send-email-keithp@keithp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 03:13:49PM -0800, Keith Packard wrote:
> +static const struct driver_info lenovo_info = {
<snip>
> +}, {
> +	/* Lenovo ThinkPad OneLink GigaLAN */
> +	USB_DEVICE(0x17ef, 0x304b),
> +	.driver_info = (unsigned long)&samsung_info,

&lenovo_info, surely.

--Kyle
