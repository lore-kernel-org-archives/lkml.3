Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaENT5B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:57:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55822 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaENT47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:56:59 -0400
Date: Wed, 14 May 2014 21:56:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: George Spelvin <linux@horizon.com>
Cc: arik@wizery.com, coelho@ti.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
Subject: Re: [PATCH] lib/crc7: Shift crc7() output left 1 bit
Message-ID: <20140514195657.GA5320@amd.pavel.ucw.cz>
References: <20140511082811.GA2695@xo-6d-61-c0.localdomain>
 <20140511091607.31386.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140511091607.31386.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2014-05-11 05:16:07, George Spelvin wrote:
> > Looks good, but should not function name change when functionality got
> > completely different?
> 
> I couldn't think of one.  Can you?
> 
> I suppose adding a _be (big-endian) suffix would be consistent.
> Is that okay with you?
> 
> To do it properly, I have to rename all of:
> 
> crc7_syndrome_table[]
> crc7_byte()
> crc7()
> 
> even though the third is the only (in-tree) user of the first two.

If the first two are static, there's no problem.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
