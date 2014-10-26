Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888AbaJZSkV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 14:40:21 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55198 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751469AbaJZSkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 14:40:20 -0400
Date: Sun, 26 Oct 2014 19:40:18 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "\\\"Rafael J. Wysocki\\\"" <rjw@rjwysocki.net>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141026184018.GA16309@amd>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
 <1413876435-11720-4-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413876435-11720-4-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> +
> +		/*
> +		 * There might have been an OOM kill while we were
> +		 * freezing tasks and the killed task might be still
> +		 * on the way out so we have to double check for race.
> +		 */

", so"

>  	/*
> +	 * PM-freezer should be notified that there might be an OOM killer on its
> +	 * way to kill and wake somebody up. This is too early and we might end
> +	 * up not killing anything but false positives are acceptable.

", but".

1,2 look good to me, 

Acked-by: Pavel Machek <pavel@ucw.cz>
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
