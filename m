Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab3HLT6z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:58:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58428 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3HLT6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:58:53 -0400
Date: Mon, 12 Aug 2013 13:04:13 -0700 (PDT)
Message-Id: <20130812.130413.1869715009441960165.davem@davemloft.net>
To: sergei.shtylyov@cogentembedded.com
Cc: clbchenlibo.chen@huawei.com, mugunthanvnm@ti.com, bigeasy@linutronix.de,
        prabhakar.csengg@gmail.com, b-liu@ti.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lizefan@huawei.com
Subject: Re: [PATCH 8/8] net: davinci_mdio: use platform_{get,set}_drvdata()
From: David Miller <davem@davemloft.net>
In-Reply-To: <520926CB.4020500@cogentembedded.com>
References: <5208E231.60104@huawei.com>
	<520926CB.4020500@cogentembedded.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 12 Aug 2013 12:58:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Date: Mon, 12 Aug 2013 22:17:47 +0400

>    Doesn't get described as well. I think you're mixing two types of
>    changes in one patchset.

Agreed, you're going to have to redo this entire patch set.
