Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab3CETz2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:55:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53670 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab3CETz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:55:27 -0500
Date: Tue, 05 Mar 2013 14:55:24 -0500 (EST)
Message-Id: <20130305.145524.1486936679665458305.davem@davemloft.net>
To: bhutchings@solarflare.com
Cc: eliezer.tamir@linux.jf.intel.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362501781.2791.19.camel@bwh-desktop.uk.solarflarecom.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	<20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
	<1362501781.2791.19.camel@bwh-desktop.uk.solarflarecom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 11:55:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>
Date: Tue, 5 Mar 2013 16:43:01 +0000

> In general it appears to require a run-time check.  You might need to
> augment <asm/timex.h>.

On the other hand, unlike get_cycles, sched_clock() is always available.
