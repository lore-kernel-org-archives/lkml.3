Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752925Ab3JSWi2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 18:38:28 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40194 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3JSWi1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 18:38:27 -0400
Date: Sat, 19 Oct 2013 18:38:25 -0400 (EDT)
Message-Id: <20131019.183825.2015665991258674429.davem@davemloft.net>
To: geyslan@gmail.com
Cc: kernel-br@googlegroups.com, herbert@gondor.hengli.com.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: n2_core: insert '!err' condition in else scope
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
References: <1382188171-25595-1-git-send-email-geyslan@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 19 Oct 2013 15:38:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Geyslan G. Bem" <geyslan@gmail.com>
Date: Sat, 19 Oct 2013 10:09:31 -0300

> This patch moves the '!err' condition into the above else scope,
> what is more obvious and has the secondary goal of avoid false-positives
> in statical analyze tools.
> 
> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>

I do not think patches should be applied to satisfy tools if the
code is semantically correct.
