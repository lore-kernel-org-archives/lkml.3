Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaIXRyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:54:14 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40730 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbaIXRyM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:54:12 -0400
Date: Wed, 24 Sep 2014 19:54:10 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@infradead.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, linux-pm@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 01/27] PM: Add helper
 pm_runtime_last_busy_and_autosuspend()
Message-ID: <20140924175410.GC1231@amd>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-2-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411575342-31048-2-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2014-09-24 21:44:51, Vinod Koul wrote:
> From: Subhransu S. Prusty <subhransu.s.prusty@intel.com>
> 
> pm_runtime_mark_last_busy and pm_runtime_put_autosuspend are used together
> in quite a lot of places. Add a helper for these.
> Also updated Documentation for this

With function name as long as the implementation... I'm not sure if
this is good helper :-).
									Pavel

> +static inline int pm_runtime_last_busy_and_autosuspend(struct device *dev)
> +{
> +	pm_runtime_mark_last_busy(dev);
> +	return pm_runtime_put_autosuspend(dev);
> +}

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
