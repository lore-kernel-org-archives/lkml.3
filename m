Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbaDOEJ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 00:09:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33136 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaDOEJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 00:09:26 -0400
Date: Tue, 15 Apr 2014 00:09:25 -0400 (EDT)
Message-Id: <20140415.000925.88207717430881624.davem@davemloft.net>
To: zhen-hual@hp.com
Cc: kas@fi.muni.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/net: cosa driver uses udelay incorrectly
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397526791-4015-1-git-send-email-zhen-hual@hp.com>
References: <1397526791-4015-1-git-send-email-zhen-hual@hp.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 21:09:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Li, Zhen-Hua" <zhen-hual@hp.com>
Date: Tue, 15 Apr 2014 09:53:11 +0800

> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> 
> In cosa driver, udelay with more than 20000 may cause __bad_udelay.
> Use msleep for instead.
> 
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>

Applied, thank you.
