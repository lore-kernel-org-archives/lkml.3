Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaDAWVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:21:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56390 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaDAWVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:21:21 -0400
Date: Tue, 01 Apr 2014 18:21:19 -0400 (EDT)
Message-Id: <20140401.182119.1195959664556774965.davem@davemloft.net>
To: rgb@redhat.com
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        eparis@redhat.com, sgrubb@redhat.com, hadi@mojatatu.com
Subject: Re: [PATCH 0/3] netlink: per-protocol bind fixup/enhancement set
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140401221215.GC21711@madcap2.tricolour.ca>
References: <cover.1396317747.git.rgb@redhat.com>
	<20140401.173354.1207821556865053650.davem@davemloft.net>
	<20140401221215.GC21711@madcap2.tricolour.ca>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 15:21:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>
Date: Tue, 1 Apr 2014 18:12:15 -0400

> Does that help?

It will when you include in your resubmission when net-next
opens back up, I don't have time to look at it right now as
I'm working on the current merge window fevorishly.
