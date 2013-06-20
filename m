Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753630Ab3FTGSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:18:38 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50186 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525Ab3FTGSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:18:35 -0400
Date: Wed, 19 Jun 2013 23:18:34 -0700 (PDT)
Message-Id: <20130619.231834.1310028807380073932.davem@davemloft.net>
To: joe@perches.com
Cc: trivial@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Trivial PATCH 29/33] ndisc: Convert use of typedef ctl_table
 to struct ctl_table
From: David Miller <davem@davemloft.net>
In-Reply-To: <9c7afffd58958d72a5f99c2e7f298b9824716f02.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
	<9c7afffd58958d72a5f99c2e7f298b9824716f02.1371177118.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 13 Jun 2013 19:37:54 -0700

> This typedef is unnecessary and should just be removed.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
