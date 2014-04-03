Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaDCPZe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:25:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44915 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbaDCPZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:25:27 -0400
Date: Thu, 03 Apr 2014 11:27:00 -0400 (EDT)
Message-Id: <20140403.112700.1784911571711405881.davem@davemloft.net>
To: yoshfuji@linux-ipv6.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        vegard.nossum@oracle.com, dan.carpenter@oracle.com
Subject: Re: [PATCH] isdnloop: Validate NUL-terminated strings from user.
From: David Miller <davem@davemloft.net>
In-Reply-To: <533B889A.2060105@linux-ipv6.org>
References: <20140401.161838.1562296825577866979.davem@davemloft.net>
	<533B889A.2060105@linux-ipv6.org>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 03 Apr 2014 08:25:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Date: Wed, 02 Apr 2014 12:48:42 +0900

> Return -EINVAL unless all of user-given strings are correctly
> NUL-terminated.
> 
> Signed-off-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>

Applied and queud up for -stable, thanks!
