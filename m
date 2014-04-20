Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaDTWVG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 18:21:06 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53960 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbaDTWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 18:21:03 -0400
Date: Sun, 20 Apr 2014 18:21:02 -0400 (EDT)
Message-Id: <20140420.182102.175207647021494785.davem@davemloft.net>
To: mcgrof@do-not-panic.com
Cc: alex.bluesman.smirnov@gmail.com, dbaryshkov@gmail.com,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, backports@vger.kernel.org
Subject: Re: [PATCH 0/3] 6lowpan: few changes to help with backports
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com>
References: <1397784176-15809-1-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 20 Apr 2014 15:21:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 17 Apr 2014 18:22:53 -0700

> Here's a few changes that can help automate the backport of 6lowpan.
> I've been carrying them around for a while, I think its best to just
> merge these upstream as its nothing controversial.

Series applied.
