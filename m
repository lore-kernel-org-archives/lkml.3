Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751601AbaI3VIg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:08:36 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49968 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaI3VIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:08:34 -0400
Date: Tue, 30 Sep 2014 17:08:32 -0400 (EDT)
Message-Id: <20140930.170832.86783104041350738.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 linux-next] irda: add __init to irlan_open
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412108644-6547-1-git-send-email-fabf@skynet.be>
References: <1412108644-6547-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 14:08:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Tue, 30 Sep 2014 22:24:04 +0200

> irlan_open is only called by __init irlan_init in same module.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
