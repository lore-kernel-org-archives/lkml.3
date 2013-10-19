Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab3JSWwF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:52:05 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40301 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701Ab3JSWwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:52:03 -0400
Date: Sat, 19 Oct 2013 18:52:01 -0400 (EDT)
Message-Id: <20131019.185201.587650685333387175.davem@davemloft.net>
To: changxiangzhong@gmail.com
Cc: vyasevich@gmail.com, nhorman@tuxdriver.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net: sctp: fix a cacc_saw_newack missetting issue
From: David Miller <davem@davemloft.net>
In-Reply-To: <1381908131-24809-1-git-send-email-changxiangzhong@gmail.com>
References: <1381908131-24809-1-git-send-email-changxiangzhong@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 19 Oct 2013 15:52:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chang Xiangzhong <changxiangzhong@gmail.com>
Date: Wed, 16 Oct 2013 09:22:11 +0200

> For for each TSN t being newly acked (Not only cumulatively,
> but also SELECTIVELY) cacc_saw_newack should be set to 1.
> 
> Signed-off-by: Xiangzhong Chang <changxiangzhong@gmail.com>

SCTP folks, can you please review this patch?

Thanks.
