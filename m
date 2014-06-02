Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbaFBHK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:10:57 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56984 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaFBHKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:10:55 -0400
Date: Mon, 02 Jun 2014 00:10:53 -0700 (PDT)
Message-Id: <20140602.001053.1333842492033184886.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: amirv@mellanox.com, ogerlitz@mellanox.com, netdev@vger.kernel.org,
        yevgenyp@mellanox.com, yuvala@mellanox.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next V6 2/2] net/mlx4_en: Use affinity hint
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401685992.3645.173.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1401683831.3645.169.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140601.215650.2131746246978305213.davem@davemloft.net>
	<1401685992.3645.173.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 00:10:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Sun, 01 Jun 2014 22:13:12 -0700

> On Sun, 2014-06-01 at 21:56 -0700, David Miller wrote:
> 
>> Indeed you have to provide a dummy version for a non-SMP build etc.
>> 
>> I'm reverting.
>> 
> 
> Hi David. I think your revert took one wrong commit.

Thanks I'll fix it up.
