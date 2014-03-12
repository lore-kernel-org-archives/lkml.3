Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaCLEMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:12:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33451 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaCLEL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:11:58 -0400
Date: Wed, 12 Mar 2014 00:11:57 -0400 (EDT)
Message-Id: <20140312.001157.1322660670638484760.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: romieu@fr.zoreil.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] r8169: fix the incorrect tx descriptor version
From: David Miller <davem@davemloft.net>
In-Reply-To: <1394521919-4257-1-git-send-email-hayeswang@realtek.com>
References: <1394521919-4257-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Mar 2014 21:11:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Tue, 11 Mar 2014 15:11:59 +0800

> The tx descriptor version of RTL8111B belong to RTL_TD_0.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Applied, thank you.
