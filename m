Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336Ab3K3TTh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 14:19:37 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41222 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940Ab3K3TTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 14:19:34 -0500
Date: Sat, 30 Nov 2013 20:19:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        pali.rohar@gmail.com, sre@ring0.de, omar.ramirez@copitl.com,
        tony@atomide.com, felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com,
        ohad@wizery.com, stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        nico@ngolde.de, dan.carpenter@oracle.com
Subject: Re: Staging: tidspbridge: disable driver
Message-ID: <20131130191931.GA5286@amd.pavel.ucw.cz>
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6662B6F95D1C4783A007CAC82A8DA641@ivogl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> However, could you elaborate on the "security bug" so I can try to
> fix it and send the patch?
> Also, what needs to be done for the tidspdriver to get out of
> staging as it seems that what I
> though initially is incorrect.

Commit

commit 930ba4a374b96560ef9fde2145cdc454a164ddcc
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Wed Nov 27 09:32:49 2013 -0800

    Staging: tidspbridge: disable driver
    
    There seems to be no active maintainer for the driver, and there
    is an
    unfixed security bug, so disable the driver for now.
    
    Hopefully someone steps up to be the maintainer, and works to get
    this
    out of staging, otherwise it will be deleted soon.
    
    Reported-by: Nico Golde <nico@ngolde.de>
    Reported-by: Dan Carpenter <dan.carpenter@oracle.com>


so perhaps Nico Golde or Dan Carpenter can elaborate? I Cc-ed them
now.

Or is it some kind of super-secret issue and still under embargo for
10 days?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
