Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab3GaAgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:36:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43980 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757395Ab3GaAgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:36:52 -0400
Date: Tue, 30 Jul 2013 17:36:51 -0700 (PDT)
Message-Id: <20130730.173651.225141933652005902.davem@davemloft.net>
To: cmetcalf@tilera.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] tile: handle 64-bit statistics in tilepro network
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <51F85BAC.70101@tilera.com>
References: <201307251642.r6PGgHx2002404@farm-0012.internal.tilera.com>
	<20130730.161634.1378046909890599017.davem@davemloft.net>
	<51F85BAC.70101@tilera.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 17:36:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Metcalf <cmetcalf@tilera.com>
Date: Tue, 30 Jul 2013 20:34:52 -0400

> On 7/30/2013 7:16 PM, David Miller wrote:
>> From: Chris Metcalf <cmetcalf@tilera.com>
>> Date: Thu, 25 Jul 2013 12:41:15 -0400
>>
>>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
>> Applied, thanks.
>>
>> Your PTP patch for the Tile driver doesn't even come close to
>> applying properly to net-next, please respin it and report if
>> you want me to apply it.
>>
>> Thanks.
> 
> It might be easiest to pull the whole series from:

No Chris, you have to freshly post the patches as a series here when
you want me to pull something.

That way it actually can get reviewed.
