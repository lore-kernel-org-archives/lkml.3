Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaFDBT4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:19:56 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50619 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbaFDBTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:19:54 -0400
Date: Tue, 03 Jun 2014 18:19:51 -0700 (PDT)
Message-Id: <20140603.181951.805355116378664370.davem@davemloft.net>
To: stephen@networkplumber.org
Cc: kys@microsoft.com, haiyangz@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] hyper-v: make uuid_le const
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140603083815.14688f8a@nehalam.linuxnetplumber.net>
References: <20140603083815.14688f8a@nehalam.linuxnetplumber.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Jun 2014 18:19:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Tue, 3 Jun 2014 08:38:15 -0700

> The uuid structure could be managed as a const in several places.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

Applied, thanks.
