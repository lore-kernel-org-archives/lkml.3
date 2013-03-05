Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab3CET5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 14:57:23 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53705 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab3CET5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 14:57:22 -0500
Date: Tue, 05 Mar 2013 14:57:19 -0500 (EST)
Message-Id: <20130305.145719.1469904264539814585.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: bhutchings@solarflare.com, eliezer.tamir@linux.jf.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, andi@firstfloor.org, hpa@zytor.com,
        eliezer@tamir.org.il
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
From: David Miller <davem@davemloft.net>
In-Reply-To: <5136282E.9080307@linux.intel.com>
References: <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
	<1362501781.2791.19.camel@bwh-desktop.uk.solarflarecom.com>
	<5136282E.9080307@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 05 Mar 2013 11:57:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Tue, 05 Mar 2013 19:15:26 +0200

> We are not very sensitive to this setting, anything on the order of
> your half round time trip plus a few standard deviations works well.
> We are busy waiting, so setting a higher value does not change the
> results much.

This makes the argument for using sched_clock() even stronger.
