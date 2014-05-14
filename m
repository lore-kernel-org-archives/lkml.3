Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbaENPDA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:03:00 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40206 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbaENPC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:02:58 -0400
Date: Wed, 14 May 2014 17:02:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "[Chander Kashyap" <chander.kashyap@linaro.org>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        len.brown@intel.com, gregkh@linuxfoundation.org,
        viresh.kumar@linaro.org, Chander Kashyap <k.chander@samsung.com>,
        Inderpal Singh <inderpal.s@samsung.com>
Subject: Re: [PATCH] PM / OPP: discard duplicate OPP additions
Message-ID: <20140514150255.GA8330@amd.pavel.ucw.cz>
References: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399966890-22926-1-git-send-email-k.chander@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Chander Kashyap <k.chander@samsung.com>
> 
> It may be possible to unregister and re-register the cpufreq driver.
> One such example is arm big-little IKS cpufreq driver. While
> re-registering the driver, same OPPs may get added again.

Hmm. Would it be better to actually delete stale OPPs?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
