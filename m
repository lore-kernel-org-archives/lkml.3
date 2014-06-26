Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaFZAqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:46:13 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39671 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755560AbaFZAqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:46:12 -0400
Date: Wed, 25 Jun 2014 17:46:11 -0700 (PDT)
Message-Id: <20140625.174611.1727406746612107344.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [trivial PATCH net-next] mac_pton: Use bool not int return
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403634048.29061.23.camel@joe-AO725>
References: <1403634048.29061.23.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 17:46:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 24 Jun 2014 11:20:48 -0700

> Use bool instead of int as the return type.
> 
> All uses are tested with !.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
