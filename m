Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbaHDNIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:08:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60338 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbaHDNIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:08:13 -0400
Date: Mon, 4 Aug 2014 15:08:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Takashi Iwai <tiwai@suse.de>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@suse.com>
Subject: Re: [PATCH] Hibernate: check unsafe page should not in e820
 reserved region
Message-ID: <20140804130810.GA23098@amd.pavel.ucw.cz>
References: <1407148396-21405-1-git-send-email-jlee@suse.com>
 <s5hlhr4v32f.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hlhr4v32f.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +
> > +	list_for_each_entry(region, &nosave_regions, list) {
> > +		if (pfn >= region->start_pfn && pfn < region->end_pfn) {
> > +			pr_err("PM: %#010llx in e820 nosave regsion: "

And while looking at it, this should probably be spelled "region".
 
...plus maybe past part of changelog here into the comment?

Otherwise looks good to me, 

Acked-by: Pavel Machek <pavel@ucw.cz>
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
