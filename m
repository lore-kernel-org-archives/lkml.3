Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaLTVBa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 16:01:30 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:45313 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaLTVB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 16:01:28 -0500
Date: Sat, 20 Dec 2014 22:01:25 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [GIT PULL] fbdev fixes for 3.19
Message-ID: <20141220210125.GB16705@amd>
References: <54899F0E.4090309@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54899F0E.4090309@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Please pull fbdev changes for 3.19.
> 
>  Tomi

v3.19-rc0 breaks video on my n900.

> Archit Taneja (7):
>       OMAPDSS: DPI: Use DPI driver data
>       OMAPDSS: DPI: Allocate driver data
>       OMAPDSS: DPI: Store dpi_data pointer in the DT port's data
>       OMAPDSS: DSS: init dss ports cleanly
>       OMAPDSS: DT: Get source endpoint by matching reg-id
>       OMAPDSS: DPI: Add support for multiple instances
>       OMAPDSS: DSS: add a param to dpi_select_source which specifies
>       it's port number

And I have these in my tree, so I should have latest fixes. Any ideas
what I should try?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
