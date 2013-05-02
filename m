Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758591Ab3EBM2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 08:28:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35196 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab3EBM2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 08:28:04 -0400
Date: Thu, 2 May 2013 14:28:02 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Colin Cross <ccross@android.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, arve@android.com,
        Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 01/10] freezer: shorten freezer sleep time using
 exponential backoff
Message-ID: <20130502122802.GB22618@amd.pavel.ucw.cz>
References: <1367271946-7239-1-git-send-email-ccross@android.com>
 <1367271946-7239-2-git-send-email-ccross@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367271946-7239-2-git-send-email-ccross@android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-04-29 14:45:37, Colin Cross wrote:
> All tasks can easily be frozen in under 10 ms, switch to using
> an initial 1 ms sleep followed by exponential backoff until
> 8 ms.  Also convert the printed time to ms instead of centiseconds.
> 
> Signed-off-by: Colin Cross <ccross@android.com>

Acked-by: Pavel Machek <pavel@ucw.cz>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
