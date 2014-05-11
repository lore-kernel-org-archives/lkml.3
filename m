Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084AbaEKKca (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 06:32:30 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36616 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757719AbaEKKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 06:32:28 -0400
Date: Sun, 11 May 2014 12:32:19 +0200
From: Pavel Machek <pavel@ucw.cz>
To: George Spelvin <linux@horizon.com>
Cc: arik@wizery.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
Subject: Re: [PATCH v2 1/3] lib/crc7: Shift crc7() output left 1 bit
Message-ID: <20140511103219.GA32609@xo-6d-61-c0.localdomain>
References: <20140511082811.GA2695@xo-6d-61-c0.localdomain>
 <20140511100211.1334.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140511100211.1334.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-05-11 06:02:11, George Spelvin wrote:
> >From 770aa22e6c9c92027e3e21797192ccabb3e7c70e Mon Sep 17 00:00:00 2001
> From: George Spelvin <linux@horizon.com>
> Date: Sat, 10 May 2014 10:32:57 -0400
> Subject: [PATCH v2 1/3] lib/crc7: Shift crc7() output left 1 bit
> 
> This eliminates a 1-bit left shift in every single caller,
> and makes the inner loop of the CRC computation more efficient.
> 
> Renamed crc7 to crc7_be (big-endian) since the interface changed.
> 
> Also purged #include <linux/crc7.h> from files that don't use it at all.
> 
> Signed-off-by: George Spelvin <linux@horizon.com>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

> v2: Functions renamed to reflect different results; Pavel Machek
> prompted me to think of something not too ugly.

Thanks!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
