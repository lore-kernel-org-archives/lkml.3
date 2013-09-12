Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756964Ab3ILVUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:20:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38774 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3ILVUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:20:22 -0400
Date: Thu, 12 Sep 2013 17:20:20 -0400 (EDT)
Message-Id: <20130912.172020.1121260191605626292.davem@davemloft.net>
To: Ian.Campbell@citrix.com
Cc: keescook@chromium.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
Subject: Re: [PATCH] xen-netback: fix possible format string flaw
From: David Miller <davem@davemloft.net>
In-Reply-To: <1378883893.3057.60.camel@dagon.hellion.org.uk>
References: <20130911043911.GA17237@www.outflux.net>
	<1378883893.3057.60.camel@dagon.hellion.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 12 Sep 2013 14:20:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Campbell <Ian.Campbell@citrix.com>
Date: Wed, 11 Sep 2013 08:18:13 +0100

> On Tue, 2013-09-10 at 21:39 -0700, Kees Cook wrote:
>> This makes sure a format string cannot accidentally leak into the
>> kthread_run() call.
>> 
>> Signed-off-by: Kees Cook <keescook@chromium.org>
> 
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Applied and queued up for -stable, thanks.
