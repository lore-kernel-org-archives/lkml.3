Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaAaJfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 04:35:39 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:65057 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbaAaJff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 04:35:35 -0500
Date: Fri, 31 Jan 2014 04:35:31 -0500
From: Tejun Heo <tj@kernel.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zoran Markovic <zoran.markovic@linaro.org>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [RFC PATCH] net: wireless: move regulatory timeout work to power
 efficient workqueue
Message-ID: <20140131093531.GA25559@mtj.dyndns.org>
References: <1391123310-6425-1-git-send-email-zoran.markovic@linaro.org>
 <1391160084.4141.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391160084.4141.1.camel@jlt4.sipsolutions.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 31, 2014 at 10:21:24AM +0100, Johannes Berg wrote:
> I'm not sure if this is part of a larger patchset actually adding that
> "system_power_efficient_wq", but maybe it'd be better to expose a
> function as an API rather than the wq struct?
> 
> Something like
> 
> scheduled_delayed_work_pwr_efficient(...)?

While there are some benefits to using dedicated functions for
specific workqueues, I don't think it brings enough benefits to
justify adding dedicated API and am unlikely to add new ones.

Thanks.

-- 
tejun
