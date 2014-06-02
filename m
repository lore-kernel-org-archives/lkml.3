Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaFBFNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 01:13:17 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:49251 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaFBFNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 01:13:16 -0400
Message-ID: <1401685992.3645.173.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net-next V6 2/2] net/mlx4_en: Use affinity hint
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: amirv@mellanox.com, ogerlitz@mellanox.com, netdev@vger.kernel.org,
        yevgenyp@mellanox.com, yuvala@mellanox.com,
        linux-kernel@vger.kernel.org
Date: Sun, 01 Jun 2014 22:13:12 -0700
In-Reply-To: <20140601.215650.2131746246978305213.davem@davemloft.net>
References: <1401029247-15196-3-git-send-email-amirv@mellanox.com>
	 <1401682610.3645.166.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1401683831.3645.169.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140601.215650.2131746246978305213.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-06-01 at 21:56 -0700, David Miller wrote:

> Indeed you have to provide a dummy version for a non-SMP build etc.
> 
> I'm reverting.
> 

Hi David. I think your revert took one wrong commit.


# git show ee39facbf82e73e468c504d2b40e83e2d223c28c | diffstat -p1 -w70
 drivers/net/ethernet/micrel/ks8851.c |   50 ++++++++++---------
 include/linux/cpumask.h              |    2 
 lib/cpumask.c                        |   64 -------------------------
 3 files changed, 28 insertions(+), 88 deletions(-)



