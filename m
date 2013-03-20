Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab3CTQXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 12:23:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58130 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3CTQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 12:23:38 -0400
Date: Wed, 20 Mar 2013 12:23:36 -0400 (EDT)
Message-Id: <20130320.122336.2213528931007672779.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, samuel@sortiz.org, netdev@vger.kernel.org,
        spender@grsecurity.net
Subject: Re: [PATCH] net/irda: add missing error path release_sock call
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130320151924.GA4955@www.outflux.net>
References: <20130320151924.GA4955@www.outflux.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Mar 2013 09:23:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Wed, 20 Mar 2013 08:19:24 -0700

> This makes sure that release_sock is called for all error conditions in
> irda_getsockopt.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Reported-by: Brad Spengler <spender@grsecurity.net>

Applied, thanks.
