Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbaFMR7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 13:59:16 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:39127 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753776AbaFMR7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 13:59:14 -0400
Message-ID: <1402682332.4478.31.camel@jlt4.sipsolutions.net>
Subject: Re: net_timedelta() affected by settimeofday() (was: [patch 12/13]
 net: mac80211: Remove silly timespec dance)
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Date: Fri, 13 Jun 2014 19:58:52 +0200
In-Reply-To: <alpine.DEB.2.10.1406121605470.5170@nanos>
References: <20140611234024.103571777@linutronix.de>
	   <20140611234607.683770899@linutronix.de>
	   <1402555774.4224.1.camel@jlt4.sipsolutions.net>
	   <alpine.DEB.2.10.1406121017500.5170@nanos>
	   <1402562114.8095.3.camel@jlt4.sipsolutions.net>
	   (sfid-20140612_103558_525847_209A5C98) <1402562399.8095.5.camel@jlt4.sipsolutions.net>
	  <alpine.DEB.2.10.1406121047280.5170@nanos>
	 <1402564914.8095.9.camel@jlt4.sipsolutions.net>
	 <alpine.DEB.2.10.1406121605470.5170@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 16:09 +0200, Thomas Gleixner wrote:

> Fair enough. Still the timespec is silly. Here is an updated version.

Makes sense, thanks. I've applied this (mac80211-next)

johannes


