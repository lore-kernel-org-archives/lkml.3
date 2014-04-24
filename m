Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbaDXQUn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 12:20:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37384 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753092AbaDXQUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 12:20:41 -0400
Date: Thu, 24 Apr 2014 18:20:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@linaro.org>
Cc: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, efault@gmx.de, wangyun@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mgorman@suse.de
Subject: Re: [RESEND PATCH V5 0/8] remove cpu_load idx
Message-ID: <20140424162029.GV11096@twins.programming.kicks-ass.net>
References: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397616209-27275-1-git-send-email-alex.shi@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



OK, this series is a lot saner, with the exception of 3/8 and
dependents.

I do still worry a bit for loosing the longer term view for the big
domains though. Sadly I don't have any really big machines.

I think the entire series is equivalent to setting LB_BIAS to false. So
I suppose we could do that for a while and if nobody reports horrible
things we could just do this.

Anybody?
