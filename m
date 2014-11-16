Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755665AbaKPToI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 14:44:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37971 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaKPToD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 14:44:03 -0500
Date: Sun, 16 Nov 2014 14:44:01 -0500 (EST)
Message-Id: <20141116.144401.2049812598100240354.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] net: dsa: replace count*size kzalloc by
 kcalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415990303-28764-1-git-send-email-fabf@skynet.be>
References: <1415990303-28764-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 16 Nov 2014 11:44:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 14 Nov 2014 19:38:23 +0100

> kcalloc manages count*sizeof overflow.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
