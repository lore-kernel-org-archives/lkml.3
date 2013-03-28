Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab3C1SBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 14:01:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43755 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3C1SBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 14:01:19 -0400
Date: Thu, 28 Mar 2013 14:01:17 -0400 (EDT)
Message-Id: <20130328.140117.68651169941346627.davem@davemloft.net>
To: tgraf@suug.ch
Cc: honkiko@gmail.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 5/6] scsi: replace obsolete NLMSG_* with type safe
 nlmsg_*
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130328144502.GG23043@casper.infradead.org>
References: <1364403195-32839-1-git-send-email-honkiko@gmail.com>
	<20130328144502.GG23043@casper.infradead.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 28 Mar 2013 11:01:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Graf <tgraf@suug.ch>
Date: Thu, 28 Mar 2013 14:45:02 +0000

> On 03/28/13 at 12:53am, Hong Zhiguo wrote:
>> Signed-off-by: Hong Zhiguo <honkiko@gmail.com>
> 
> There are some formatting errors but the Netlink bits themselves
> look good.
> 

I'll fix these up too when I commit.
