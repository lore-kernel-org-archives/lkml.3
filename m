Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab3EUHOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:14:47 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44685 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3EUHOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:14:45 -0400
Date: Tue, 21 May 2013 00:14:44 -0700 (PDT)
Message-Id: <20130521.001444.1361294042663568537.davem@davemloft.net>
To: eilong@broadcom.com
Cc: eliezer.tamir@linux.intel.com, or.gerlitz@gmail.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: David Miller <davem@davemloft.net>
In-Reply-To: <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
References: <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
	<519B1A2B.4010909@linux.intel.com>
	<1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 21 May 2013 00:14:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eilon Greenstein" <eilong@broadcom.com>
Date: Tue, 21 May 2013 10:06:43 +0300

> Hopefully this series will be accepted so we can send follow up support
> for the bnx2x as well.

I think in two or three more iterations it will be merged.

There are no objections on the fundamentals, it's just implementation
details and coding style at this point.
