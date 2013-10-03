Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab3JCTlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:41:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38381 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab3JCTlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:41:12 -0400
Date: Thu, 03 Oct 2013 15:41:08 -0400 (EDT)
Message-Id: <20131003.154108.1994295488096974739.davem@davemloft.net>
To: peter.senna@gmail.com
Cc: jcliburn@gmail.com, chris.snook@gmail.com, jkosina@suse.cz,
        rdunlap@infradead.org, standby24x7@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 08/19 v2] net: atl1c: Change variable type to bool
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380716391-20214-1-git-send-email-peter.senna@gmail.com>
References: <1380716391-20214-1-git-send-email-peter.senna@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 03 Oct 2013 12:41:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Senna Tschudin <peter.senna@gmail.com>
Date: Wed,  2 Oct 2013 14:19:48 +0200

> The variable ret is only assigned the values true and false.
> The function atl1c_read_eeprom already returns bool. Change
> ret type to bool.
> 
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> @exists@
> type T;
> identifier b;
> @@
> - T
> + bool
>   b = ...;
>   ... when any
>   b = \(true\|false\)
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Applied.
