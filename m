Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaGVEij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:38:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41349 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaGVEih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:38:37 -0400
Date: Mon, 21 Jul 2014 21:38:36 -0700 (PDT)
Message-Id: <20140721.213836.2235386730808030831.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org, sparclinux@vger.kernel.org
Subject: Re: [RESEND][PATCH] sparc: use %s for unaligned panic
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140630203759.GA4764@www.outflux.net>
References: <20140630203759.GA4764@www.outflux.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Jul 2014 21:38:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Mon, 30 Jun 2014 13:37:59 -0700

> Since unaligned_panic() takes a literal string, make sure it can never
> accidentally be used as a format string.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Unnecessary, but harmless, so applied to sparc-next, thanks.
