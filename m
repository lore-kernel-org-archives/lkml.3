Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbaEOGGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:06:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47448 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaEOGGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:06:10 -0400
Date: Thu, 15 May 2014 08:06:08 +0200
From: Pavel Machek <pavel@ucw.cz>
To: George Spelvin <linux@horizon.com>
Cc: arik@wizery.com, coelho@ti.com, david.gnedt@davizone.at, eliad@wizery.com,
        jan.nikitenko@gmail.com, laurent.pinchart+renesas@ideasonboard.com,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com, luca@coelho.fi, tony@atomide.com
Subject: Re: [PATCH] lib/crc7: Shift crc7() output left 1 bit
Message-ID: <20140515060607.GA28219@amd.pavel.ucw.cz>
References: <20140514195657.GA5320@amd.pavel.ucw.cz>
 <20140515003225.23627.qmail@ns.horizon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515003225.23627.qmail@ns.horizon.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-05-14 20:32:25, George Spelvin wrote:
> Pavel Machek wrote;
> > On Sun 2014-05-11 05:16:07, George Spelvin wrote:
> >> To do it properly, I have to rename all of:
> >> 
> >> crc7_syndrome_table[]
> >> crc7_byte()
> >> crc7()
> >> 
> >> even though the third is the only (in-tree) user of the first two.
> 
> > If the first two are static, there's no problem.
> 
> They're not; they're exported from the header (even though, as
> I mentioned, their only user is crc7()).
> 
> So my patch v2 1/3 renamed all three.

That's one way.

Other would be to make them static so people can't use old interfaces
by mistake.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
