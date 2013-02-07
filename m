Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422641Ab3BGT3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 14:29:18 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53281 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab3BGT3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 14:29:16 -0500
Date: Thu, 07 Feb 2013 14:29:11 -0500 (EST)
Message-Id: <20130207.142911.101451648518406435.davem@davemloft.net>
To: keescook@chromium.org
Cc: stephen@networkplumber.org, linux-kernel@vger.kernel.org, rob@landley.net,
        kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, edumazet@google.com, nhorman@tuxdriver.com,
        ycheng@google.com, davidshan@tencent.com, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, w@1wt.eu
Subject: Re: [PATCH] tcp: sysctl to disable TCP simultaneous connect
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAGXu5jJiupzommJYPEYQnk-4i9FUKai0NcPnihLN-QpWV64jtQ@mail.gmail.com>
References: <20130207175240.GA12520@www.outflux.net>
	<20130207103950.662698ea@nehalam.linuxnetplumber.net>
	<CAGXu5jJiupzommJYPEYQnk-4i9FUKai0NcPnihLN-QpWV64jtQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Thu, 7 Feb 2013 10:44:02 -0800

> David: I know you aren't a fan of this patch, but I'd like to try to
> convince you. :) This leaves the feature enabled and add a toggle for
> systems (like Chrome OS) that don't want to risk this DoS at all.
> There are so very many other toggle, I don't see why this one would be
> a problem to add.

We're not in the business of allowing the changing of the TCP state
machine behavior like this.  Sorry.
