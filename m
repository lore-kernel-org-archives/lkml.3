Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030576Ab3DSOSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:18:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34853 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030473Ab3DSOSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:18:41 -0400
Date: Fri, 19 Apr 2013 15:17:49 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jongsung Kim <neidhard.kim@lge.com>
Cc: gregkh@linuxfoundation.org, jslaby@suse.cz, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND][PATCH] ARM: PL011: add support for extended FIFO-size
	of PL011-r1p5
Message-ID: <20130419141748.GU14496@n2100.arm.linux.org.uk>
References: <201304151445.25151.neidhard.kim@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304151445.25151.neidhard.kim@lge.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 02:45:25PM +0900, Jongsung Kim wrote:
> The latest r1p5-revision of the ARM PL011 UART has 32-byte FIFOs,
> while all earlier ones have 16-byte FIFOs. This patch suggests
> a way to set the FIFO-size correctly & flexibly by using a member
> function named get_fifosize, rather than using the fifosize member
> variable. The function takes the UARTPeriphID, and returns the
> correct FIFO size.

Same comments as previous version.
