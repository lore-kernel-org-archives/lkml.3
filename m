Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaFLGu3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 02:50:29 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:33852 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932134AbaFLGu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 02:50:27 -0400
Message-ID: <1402555774.4224.1.camel@jlt4.sipsolutions.net>
Subject: Re: [patch 12/13] net: mac80211: Remove silly timespec dance
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 12 Jun 2014 08:49:34 +0200
In-Reply-To: <20140611234607.683770899@linutronix.de>
References: <20140611234024.103571777@linutronix.de>
	 <20140611234607.683770899@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 23:59 +0000, Thomas Gleixner wrote:

> +	msrmnt = ktime_to_ms(net_timedelta(skb_arv));

This is probably more of a question about net_timedelta(), but is
ktime_get_real() really appropriate for duration measurements? Isn't
that non-monotonic?

johannes

