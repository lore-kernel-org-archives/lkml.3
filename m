Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099Ab3JSXM3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 19:12:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40409 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab3JSXM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 19:12:28 -0400
Date: Sat, 19 Oct 2013 19:12:26 -0400 (EDT)
Message-Id: <20131019.191226.2164346458344896632.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] net: Remove extern from function prototypes
From: David Miller <davem@davemloft.net>
In-Reply-To: <cover.1382129045.git.joe@perches.com>
References: <cover.1382129045.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 19 Oct 2013 16:12:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 18 Oct 2013 13:48:21 -0700

> Remove the remainder of extern function prototypes from net/.../*.h files.

Series applied, thanks a lot Joe.
