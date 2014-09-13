Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305AbaIMUDJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2014 16:03:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37696 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175AbaIMUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2014 16:03:07 -0400
Date: Sat, 13 Sep 2014 16:03:02 -0400 (EDT)
Message-Id: <20140913.160302.698126980021738731.davem@davemloft.net>
To: joe@perches.com
Cc: xypron.glpk@gmx.de, david.daney@cavium.com, luka@openwrt.org,
        willemb@google.com, rmk+kernel@arm.linux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdev: octeon_mgmt: ISO C90 forbids mixed
 declarations and code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410635472.917.1.camel@joe-AO725>
References: <1410635108-3589-1-git-send-email-xypron.glpk@gmx.de>
	<1410635472.917.1.camel@joe-AO725>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Sep 2014 13:03:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 13 Sep 2014 12:11:12 -0700

> On Sat, 2014-09-13 at 21:05 +0200, Heinrich Schuchardt wrote:
>> Compiling with OCTEON_MGMT_ETHERNET gives a warning
>> drivers/net/ethernet/octeon/octeon_mgmt.c:295:4:
>> warning: ISO C90 forbids mixed declarations and code
>> [-Wdeclaration-after-statement]
> 
> Maybe better to move the memset after the declaration.

Totally agree, keep the variable in the innermost scope
in which it is used.
