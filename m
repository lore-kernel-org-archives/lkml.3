Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJAGDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 02:03:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54858 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaJAGDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 02:03:31 -0400
Date: Wed, 01 Oct 2014 02:03:30 -0400 (EDT)
Message-Id: <20141001.020330.1107419144608142662.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ieee802154: fix __init functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412141266-12258-1-git-send-email-fabf@skynet.be>
References: <1412141266-12258-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 23:03:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed,  1 Oct 2014 07:27:46 +0200

> Commit 3243acd37fd9
> ("ieee802154: add __init to lowpan_frags_sysctl_register")
> 
> added __init to lowpan_frags_ns_sysctl_register instead of
> lowpan_frags_sysctl_register
> 
> Suggested-by: Alexander Aring <alex.aring@gmail.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks for sorting this out.
