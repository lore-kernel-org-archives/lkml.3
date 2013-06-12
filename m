Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3FLUgG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:36:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59726 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755220Ab3FLUgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:36:04 -0400
Date: Wed, 12 Jun 2013 13:36:03 -0700 (PDT)
Message-Id: <20130612.133603.339419203281101086.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless 2013-06-12
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130612150926.GC11589@tuxdriver.com>
References: <20130606190929.GB18827@tuxdriver.com>
	<20130612150926.GC11589@tuxdriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 12 Jun 2013 11:09:26 -0400

> For now I have dropped the mac80211 tree from this request.
> We are developing a little backlog of fixes and I would like to
> avoid introducing any more uncertainty to this pull request for the
> 3.10 stream.  All the other bits are the same as what was in the
> 2013-06-06 request, including the ath9k fixes intended to address
> the problems observed by Linus w/ his Pixel, and a CVE fix for a
> potential security issue in the b43 driver.

Pulled, thanks John.
