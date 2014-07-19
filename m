Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755208AbaGSNtK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:49:10 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40440 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900AbaGSNtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:49:07 -0400
Date: Sat, 19 Jul 2014 15:49:04 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joerg Roedel <joro@8bytes.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140719134904.GA2852@amd.pavel.ucw.cz>
References: <1405684643-30234-1-git-send-email-joro@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405684643-30234-1-git-send-email-joro@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> These patches improve the data structure by adding a radix
> tree to the linked list structure to improve random access
> performance from O(n) to O(log_b(n)), where b depends on the
> architecture (b=512 on amd64, 1024 in i386).

Are you sure? From your other mail, you said you are adding just a
single page. I'd expect random access performance to go from

O(n) to O(n/1024) in such case?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
