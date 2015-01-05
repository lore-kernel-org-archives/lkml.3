Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbbAEDYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 22:24:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45978 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773AbbAEDYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 22:24:50 -0500
Date: Sun, 04 Jan 2015 22:24:48 -0500 (EST)
Message-Id: <20150104.222448.2069931734048612119.davem@davemloft.net>
To: joe@perches.com
Cc: shahed.shaikh@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] qlcnic: Fix dump_skb output
From: David Miller <davem@davemloft.net>
In-Reply-To: <1420336216.2619.9.camel@perches.com>
References: <1420336216.2619.9.camel@perches.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 04 Jan 2015 19:24:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Sat, 03 Jan 2015 17:50:16 -0800

> Use normal facilities to avoid printing each byte
> on a separate line.
> 
> Now emits at KERN_DEBUG instead of KERN_INFO.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

This looks fine, applied, thanks Joe.
