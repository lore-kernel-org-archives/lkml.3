Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbaFQEaH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 00:30:07 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51273 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378AbaFQEaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 00:30:04 -0400
Date: Mon, 16 Jun 2014 21:30:03 -0700 (PDT)
Message-Id: <20140616.213003.1138477495538114124.davem@davemloft.net>
To: tylerwhall@gmail.com
Cc: netdev@vger.kernel.org, socketcan@hartkopp.net, nautsch2@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] slcan: Port write_wakeup deadlock fix from slip
From: David Miller <davem@davemloft.net>
In-Reply-To: <1402885397-21062-2-git-send-email-tylerwhall@gmail.com>
References: <1402885397-21062-1-git-send-email-tylerwhall@gmail.com>
	<1402885397-21062-2-git-send-email-tylerwhall@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Jun 2014 21:30:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tyler Hall <tylerwhall@gmail.com>
Date: Sun, 15 Jun 2014 22:23:17 -0400

> The commit "slip: Fix deadlock in write_wakeup" fixes a deadlock caused
> by a change made in both slcan and slip. This is a direct port of that
> fix.
> 
> Signed-off-by: Tyler Hall <tylerwhall@gmail.com>

Applied and queued up for -stable.
