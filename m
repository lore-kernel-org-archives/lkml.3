Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbaADMvQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 07:51:16 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52879 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbaADMvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 07:51:10 -0500
Date: Sat, 4 Jan 2014 13:51:08 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: tomi.valkeinen@ti.com, plagnioj@jcrosoft.com, pali.rohar@gmail.com,
        linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH] ARM: OMAPFB: panel-sony-acx565akm: fix missing mutex
 unlocks
Message-ID: <20140104125108.GA22339@amd.pavel.ucw.cz>
References: <1388420272-5132-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388420272-5132-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-12-30 18:17:52, Ivaylo Dimitrov wrote:
> From: Ivaylo Dimitrov <freemangordon@abv.bg>
> 
> Commit c37dd677988ca50bc8bc60ab5ab053720583c168 fixes the unbalanced
> unlock in acx565akm_enable but introduces another problem - if
> acx565akm_panel_power_on exits early, the mutex is not unlocked. Fix
> that by unlocking the mutex on early return. Also add mutex protection in
> acx565akm_panel_power_off and remove an unused variable
> 
> Signed-off-by: Ivaylo Dimitrov <freemangordon@abv.bg>

Reviewed-by: Pavel Machek <pavel@ucw.cz>
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
