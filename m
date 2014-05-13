Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaEMVoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:44:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752330AbaEMVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:44:31 -0400
Date: Tue, 13 May 2014 17:44:30 -0400 (EDT)
Message-Id: <20140513.174430.1035414930183443631.davem@davemloft.net>
To: reksio@newterm.pl
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver/net/ethernet/ec_bhf.c: fix sparse warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140511075608.GA9034@newterm.pl>
References: <20140511075608.GA9034@newterm.pl>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 May 2014 14:44:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darek Marcinkiewicz <reksio@newterm.pl>
Date: Sun, 11 May 2014 09:56:08 +0200

> 
> Sparse was reporting quite a few warnings for the driver.
> Those get fixed by this patch.

This is not a proper submission, you need to provide a proper
signoff with your patch.

Please make a new, fresh, patch posting, with the necessary
signoff in your commit message.

Thanks.
