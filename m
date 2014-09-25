Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbaIYI32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:29:28 -0400
Received: from mga14.intel.com ([192.55.52.115]:31529 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaIYI3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:29:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,595,1406617200"; 
   d="scan'208";a="596609656"
Date: Thu, 25 Sep 2014 13:30:38 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 01/27] PM: Add helper
 pm_runtime_last_busy_and_autosuspend()
Message-ID: <20140925080038.GX24663@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-2-git-send-email-vinod.koul@intel.com>
 <20140924175410.GC1231@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140924175410.GC1231@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 07:54:10PM +0200, Pavel Machek wrote:
> On Wed 2014-09-24 21:44:51, Vinod Koul wrote:
> > From: Subhransu S. Prusty <subhransu.s.prusty@intel.com>
> > 
> > pm_runtime_mark_last_busy and pm_runtime_put_autosuspend are used together
> > in quite a lot of places. Add a helper for these.
> > Also updated Documentation for this
> 
> With function name as long as the implementation... I'm not sure if
> this is good helper :-).
am all ears if that is a general consensus to cut down on length and
suggestions welcome :)

-- 
~Vinod

> 									Pavel
> 
> > +static inline int pm_runtime_last_busy_and_autosuspend(struct device *dev)
> > +{
> > +	pm_runtime_mark_last_busy(dev);
> > +	return pm_runtime_put_autosuspend(dev);
> > +}
> 
> -- 
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
