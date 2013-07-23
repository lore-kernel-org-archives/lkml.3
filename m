Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3GWHSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 03:18:07 -0400
Received: from mail.sysmocom.de ([144.76.43.93]:57395 "EHLO mail.sysmocom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab3GWHSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 03:18:06 -0400
Date: Tue, 23 Jul 2013 09:18:02 +0200
From: Holger Hans Peter Freyther <holger@freyther.de>
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] timer_list: Correct the show function for timer_list by
 using iter->now
Message-ID: <20130723071802.GA7966@xiaoyu.lan>
References: <20130720054300.GA29718@xiaoyu.lan>
 <1374527911-43084-1-git-send-email-nzimmer@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374527911-43084-1-git-send-email-nzimmer@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 04:18:31PM -0500, Nathan Zimmer wrote:
> This patch corrects the issue with /proc/timer_list reported by Holger.
> When reading from the proc file with a sufficently small buffer, 2k so not
> really that small, there was one could get hung trying to read the file a
> chunk at a time.

I think it makes sense to always use iter->now but it does not solve
the issue with dropbear/my test case. Or is this meant to be applied
on top of the previous patch?


holger

