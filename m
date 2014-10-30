Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760969AbaJ3Two (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 15:52:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58617 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759489AbaJ3Twn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 15:52:43 -0400
Date: Thu, 30 Oct 2014 15:52:40 -0400 (EDT)
Message-Id: <20141030.155240.619965312244569032.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] ipx: remove all unnecessary castings on
 ntohl
From: David Miller <davem@davemloft.net>
In-Reply-To: <1414571502-9231-1-git-send-email-fabf@skynet.be>
References: <1414571502-9231-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Oct 2014 12:52:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed, 29 Oct 2014 09:31:42 +0100

> Apply commit e0f36310f793
> ("ipx: remove unnecessary casting on ntohl")
> to all seq_printf/08lX
> 
> Inspired-by: "David S. Miller" <davem@davemloft.net>
> Inspired-by: Joe Perches <joe@perches.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
