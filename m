Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3CCGoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 01:44:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48315 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3CCGoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 01:44:22 -0500
Date: Sun, 03 Mar 2013 01:44:21 -0500 (EST)
Message-Id: <20130303.014421.1879042322636699922.davem@davemloft.net>
To: silviupopescu1990@gmail.com
Cc: netdev@vger.kernel.org, sjur.brandeland@stericsson.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] caif_dev: fix sparse warnings for caif_flow_cb
From: David Miller <davem@davemloft.net>
In-Reply-To: <1362253519-13014-1-git-send-email-silviupopescu1990@gmail.com>
References: <1362253519-13014-1-git-send-email-silviupopescu1990@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 02 Mar 2013 22:44:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Date: Sat,  2 Mar 2013 21:45:19 +0200

> This fixed the following sparse warning:
> net/caif/caif_dev.c:121:6: warning: symbol 'caif_flow_cb' was not
> declared. Should it be static?
> 
> Signed-off-by: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>

Applied.
