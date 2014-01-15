Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbaAOWzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:55:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41497 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbaAOWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:55:48 -0500
Date: Wed, 15 Jan 2014 14:55:47 -0800 (PST)
Message-Id: <20140115.145547.1868806980328924895.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: jeffrey.t.kirsher@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: Re: [PATCH] [trivial] ixgbe: Fix format string in ixgbe_fcoe.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389716082-23395-1-git-send-email-standby24x7@gmail.com>
References: <1389716082-23395-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Wed, 15 Jan 2014 01:14:42 +0900

> cppcheck detected following warning in ixgbe_fcoe.c
> (warning) %d in format string (no. 1) requires 'int' but the
> argument type is 'unsigned int'.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Intel folks, please be sure to pick this up.
