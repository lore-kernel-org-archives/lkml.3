Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbaENEsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 00:48:04 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47936 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaENEsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 00:48:00 -0400
Date: Wed, 14 May 2014 00:47:58 -0400 (EDT)
Message-Id: <20140514.004758.1002719194974082826.davem@davemloft.net>
To: george.cherian@ti.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mugunthanvnm@ti.com,
        balbi@ti.com, zonque@gmail.com, mpa@pengutronix.de,
        tklauser@distanz.ch
Subject: Re: [PATCH v3 0/3] TI CPSW Cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399870281-27200-1-git-send-email-george.cherian@ti.com>
References: <1399870281-27200-1-git-send-email-george.cherian@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 May 2014 21:47:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>
Date: Mon, 12 May 2014 10:21:18 +0530

> This series does some minimal cleanups.
> 	-Conversion of pr_*() to dev_*()
> 	-Convert kzalloc to devm_kzalloc.

Series applied to net-next, thanks.
