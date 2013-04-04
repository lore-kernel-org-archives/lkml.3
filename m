Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765503Ab3DDXmk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 19:42:40 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:47877 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765468Ab3DDXmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 19:42:39 -0400
Date: Fri, 5 Apr 2013 01:42:29 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: David Miller <davem@davemloft.net>
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/8] r8169: Remove firmware code
Message-ID: <20130404234229.GA13629@electric-eye.fr.zoreil.com>
References: <1364824539-4156-1-git-send-email-hayeswang@realtek.com>
 <1364891022-3220-1-git-send-email-hayeswang@realtek.com>
 <20130404.174717.2232220782916755499.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130404.174717.2232220782916755499.davem@davemloft.net>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> :
[...]
> I see there is still some discussion about dependencies between
> patch #5 and #6, is that resolved?

Yes.

> If so, should I just apply this series as-is ?

Yes.

- the series is imho -stable unfriendly: whoever wants to figure what
  should be fed into a -stable branch will have a hard time. :o/
- the driver could had been more careful about firmware version/magic
  checks and firmware opcodes recycling. It's a bit late. It won't
  necessarily hurt.
- there is a whole release cycle ahead to find problems - if any - due
  to the hw_start flow change. It seems sane.
- the relative amount of binary like cruft is going down.

I am not overflowed with enthusiasm but the gain should exceed the pain.

-- 
Ueimor
