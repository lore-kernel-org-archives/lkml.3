Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750922AbaHEXpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:45:12 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60566 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaHEXpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:45:09 -0400
Date: Tue, 05 Aug 2014 16:45:07 -0700 (PDT)
Message-Id: <20140805.164507.779439224391996731.davem@davemloft.net>
To: tanure@linux.com
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        gregory.v.rose@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernelnewbies@kernelnewbies.org
Subject: Re: [PATCH] drivers: net: ethernet: intel: i40e: Fix missing
 uapi/linux/dcbnl.h include in i40e_fcoe.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140805131143.GA29685@ttmp-linux>
References: <20140805131143.GA29685@ttmp-linux>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 16:45:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lucas Tanure <tanure@linux.com>
Date: Tue, 5 Aug 2014 10:11:43 -0300

> Fix missing include in intel i40e driver. Without this include linux next
> tree won't compile.
> 
> Signed-off-by: Lucas Tanure <tanure@linux.com>

Applied, thank you.
