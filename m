Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447Ab3CSN1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:27:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42453 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3CSN1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:27:40 -0400
Date: Tue, 19 Mar 2013 09:27:35 -0400 (EDT)
Message-Id: <20130319.092735.322670260944589079.davem@davemloft.net>
To: baker.kernel@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        baker.zhang@gmail.com
Subject: Re: [PATCH] use xfrm direction when lookup policy
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363696786-11128-1-git-send-email-baker.zhang@gmail.com>
References: <1363696786-11128-1-git-send-email-baker.zhang@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 06:27:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Baker Zhang <baker.kernel@gmail.com>
Date: Tue, 19 Mar 2013 20:39:46 +0800

> +static inline int flow_to_policy_dir(int dir)

Please do not use inline in foo.c files, just let the compiler decide
whether inlining is a good idea or not.

Thanks.
