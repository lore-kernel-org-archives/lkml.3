Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3LFBoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:44:14 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60439 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab3LFBoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:44:13 -0500
Date: Thu, 05 Dec 2013 20:44:11 -0500 (EST)
Message-Id: <20131205.204411.86525521936068436.davem@davemloft.net>
To: zwu.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wuzhy@linux.vnet.ibm.com
Subject: Re: [PATCH 1/2] macvtap: update file current position
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386149341-10485-1-git-send-email-zwu.kernel@gmail.com>
References: <1386149341-10485-1-git-send-email-zwu.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Dec 2013 17:44:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhi Yong Wu <zwu.kernel@gmail.com>
Date: Wed,  4 Dec 2013 17:29:00 +0800

> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

The tun driver seems to have the same exact bug, please if you are going
to fix one then fix the other too.

Thanks.
