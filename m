Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaHKVkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 17:40:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59201 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752258AbaHKVkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 17:40:31 -0400
Date: Mon, 11 Aug 2014 14:38:42 -0700 (PDT)
Message-Id: <20140811.143842.1765285724858937860.davem@davemloft.net>
To: sanjeev_sharma@mentor.com
Cc: gregkh@linuxfoundation.org, steve.glendinning@shawell.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc: replace WARN_ON() with WARN_ON_SMP()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1407744983-29289-1-git-send-email-sanjeev_sharma@mentor.com>
References: <1407744983-29289-1-git-send-email-sanjeev_sharma@mentor.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Aug 2014 14:40:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Date: Mon, 11 Aug 2014 13:46:23 +0530

> spin_is_locked() always return false in uniprocessor configuration and therefore it
> would be advise to repalce with WARN_ON_SMP().
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>

This looks fine, applied, thanks.
