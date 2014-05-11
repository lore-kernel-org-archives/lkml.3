Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbaEKKgM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 06:36:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36720 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489AbaEKKgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 06:36:10 -0400
Date: Sun, 11 May 2014 12:36:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: George Spelvin <linux@horizon.com>
Cc: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
Subject: Re: [PATCH 3/3] drivers/net/wireless/ti/wl*/spi.c: Simplify CRC
 computation
Message-ID: <20140511103602.GC32609@xo-6d-61-c0.localdomain>
References: <20140511100211.1334.qmail@ns.horizon.com>
 <20140511100743.1712.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140511100743.1712.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-05-11 06:07:43, George Spelvin wrote:
> These devices require commands stored in buffers in an odd order,
> different from that in which the CRC is computed.
> 
> Rather than make two copies of the commands in two different orders,
> form the commands in logical (CRC) order, append the CRC, then byte-swap
> in place to the desired order.
> 
> The old code worked fine, I'm just scratching an "ugh, that's ugly"
> itch.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
