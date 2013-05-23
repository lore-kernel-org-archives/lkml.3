Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758972Ab3EWTNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:13:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33220 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757918Ab3EWTNb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:13:31 -0400
Date: Thu, 23 May 2013 12:13:29 -0700 (PDT)
Message-Id: <20130523.121329.781995429475451805.davem@davemloft.net>
To: emilio@elopez.com.ar
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] net: ethernet: sun: drop unused variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <519E117F.9040707@elopez.com.ar>
References: <1369267057-9371-3-git-send-email-emilio@elopez.com.ar>
	<20130522.234318.1664796969540142910.davem@davemloft.net>
	<519E117F.9040707@elopez.com.ar>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio López <emilio@elopez.com.ar>
Date: Thu, 23 May 2013 09:54:23 -0300

> Hi David,
> 
> El 23/05/13 03:43, David Miller escribió:
>> From: Emilio López <emilio@elopez.com.ar>
>> Date: Wed, 22 May 2013 20:57:37 -0300
>> 
>>> Commit bfd428d ("net: ethernet: sun: initialize variables directly")
>>> dropped the only loop that was using i but did not remove the actual
>>> variable, therefore causing a warning when building. This patch drops
>>> the now redundant line.
>>>
>>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>>> Signed-off-by: Emilio López <emilio@elopez.com.ar>
>> 
>> Applied.
> 
> I see that you applied the series in net instead of net-next; the
> previous patches were in net-next only. This will cause build breakage
> in net because the loop is still there.

My bad, I'll fix this up.
