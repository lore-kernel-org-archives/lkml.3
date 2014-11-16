Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaKPTn7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:43:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37969 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755596AbaKPTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:43:57 -0500
Date: Sun, 16 Nov 2014 14:43:55 -0500 (EST)
Message-Id: <20141116.144355.100657609191730461.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] net: dsa: replace count*size kmalloc by
 kmalloc_array
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415990202-28673-1-git-send-email-fabf@skynet.be>
References: <1415990202-28673-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 11:43:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 14 Nov 2014 19:36:42 +0100

> kmalloc_array manages count*sizeof overflow.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, and yes I read Joe's feedback and the rest of this thread
wrt. sizeof(u8/s8).  That can be done as a followup.
