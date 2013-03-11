Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab3CKLkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:40:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60243 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:40:39 -0400
Date: Mon, 11 Mar 2013 07:40:44 -0400 (EDT)
Message-Id: <20130311.074044.1360965348131709747.davem@davemloft.net>
To: socketcan@hartkopp.net
Cc: valentin.ilie@gmail.com, linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] net: can: af_can.c: Fix checkpatch warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <513D8193.3080405@hartkopp.net>
References: <1362918526-26730-1-git-send-email-valentin.ilie@gmail.com>
	<1362950113-25515-1-git-send-email-valentin.ilie@gmail.com>
	<513D8193.3080405@hartkopp.net>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 11 Mar 2013 04:40:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>
Date: Mon, 11 Mar 2013 08:02:43 +0100

> On 10.03.2013 22:15, Valentin Ilie wrote:
> 
>> Replace printk(KERN_ERR with pr_err
>> Add space before {
>> Removed OOM messages
>> 
>> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
> 
> 
> Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>

Applied, thanks.
