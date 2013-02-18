Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3BRTp5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 14:45:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48935 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab3BRTp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 14:45:56 -0500
Date: Mon, 18 Feb 2013 14:45:54 -0500 (EST)
Message-Id: <20130218.144554.1124057233943399415.davem@davemloft.net>
To: gmate.amit@gmail.com
Cc: jdmason@kudzu.us, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ethernet: neterion: vxge: vxge-traffic.c: fix for a
 potential NULL pointer dereference
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361037394-14731-1-git-send-email-gmate.amit@gmail.com>
References: <1361037394-14731-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Amit Mehta <gmate.amit@gmail.com>
Date: Sat, 16 Feb 2013 09:56:34 -0800

> fix for a potential NULL pointer dereference and removal of a redundant
> assignment operation. Found using smatch.
> 
> Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>

Obviously whoever wrote this code intended for ALARM_CLEARED
and EVENT_UNKNOWN events to not be logged.

But you're changing that.

I'm not applying this patch, sorry.
