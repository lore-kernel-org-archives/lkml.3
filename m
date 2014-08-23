Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaHWClQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 22:41:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56842 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaHWClO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 22:41:14 -0400
Date: Fri, 22 Aug 2014 19:41:11 -0700 (PDT)
Message-Id: <20140822.194111.760144805197214266.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] r8152: firmware support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394712342-15778-16-Taiwan-albertk@realtek.com>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 22 Aug 2014 19:41:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Wed, 20 Aug 2014 16:58:35 +0800

> Parsing, checking, and writing the firmware.

You haven't told us why you need to do this.

These are just programming registers in the chip, and I see no reason
to not keep these in the driver with real code.

I'm not applying this series, you haven't explained what is happening
here and the reason for doing so.  Ironically, that's exactly what you
are supposed to provide in this 0/4 header email.
