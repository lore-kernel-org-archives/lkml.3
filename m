Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbaEOUly (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 16:41:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35923 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbaEOUlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 16:41:53 -0400
Date: Thu, 15 May 2014 16:41:51 -0400 (EDT)
Message-Id: <20140515.164151.1902059191982568800.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ti: Remove trailing semicolon from do {...} while
 (0) macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <de49b7a2734337157b439afe30c39e9b40bc6e0f.1400094804.git.joe@perches.com>
References: <cover.1400094804.git.joe@perches.com>
	<de49b7a2734337157b439afe30c39e9b40bc6e0f.1400094804.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 May 2014 13:41:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 14 May 2014 12:15:13 -0700

> These should not have trailing semicolons so remove them.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.
