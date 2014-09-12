Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaILWYQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:24:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52084 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbaILWYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:24:14 -0400
Date: Fri, 12 Sep 2014 18:24:12 -0400 (EDT)
Message-Id: <20140912.182412.574409630539820830.davem@davemloft.net>
To: mark.einon@gmail.com
Cc: gary.zambrano@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] drivers: net: b44: Fix typo in returning
 multicast stats
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410473989-2049-1-git-send-email-mark.einon@gmail.com>
References: <1410473989-2049-1-git-send-email-mark.einon@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Sep 2014 15:24:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Einon <mark.einon@gmail.com>
Date: Thu, 11 Sep 2014 23:19:49 +0100

> nstat->multicast refers to received packets, not transmitted as
> is returned here. Change it so that received packet stats are
> given.
> 
> Signed-off-by: Mark Einon <mark.einon@gmail.com>

Applied, thank you.
