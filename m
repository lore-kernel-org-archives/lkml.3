Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095AbaEFRQq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:16:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41605 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbaEFRQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:16:45 -0400
Date: Tue, 06 May 2014 13:16:43 -0400 (EDT)
Message-Id: <20140506.131643.994244006906866938.davem@davemloft.net>
To: josh@joshtriplett.org
Cc: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506164108.GA20536@cloud>
References: <20140506155703.GA20391@cloud>
	<20140506.115941.428706504757835279.davem@davemloft.net>
	<20140506164108.GA20536@cloud>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 10:16:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: josh@joshtriplett.org
Date: Tue, 6 May 2014 09:41:08 -0700

> Every KB of RAM costs real money and SoC die area (for eDRAM/eSRAM).

Another poster commented that 16MB of DRAM would be cheaper than
the 2MB of ram you have on these boards, probably one that fits
your size profile is available as well.

2MB is just a rediculous restriction.

And last time I checked Linux wasn't a special purpose operating
system, but lucky for you I hear there are lots of those around.
