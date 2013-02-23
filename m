Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758407Ab3BWSyn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 13:54:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56952 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882Ab3BWSyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 13:54:41 -0500
Date: Sat, 23 Feb 2013 13:54:39 -0500 (EST)
Message-Id: <20130223.135439.1188316565117960228.davem@davemloft.net>
To: keescook@chromium.org
Cc: linux-kernel@vger.kernel.org, shemminger@vyatta.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH] vxlan: remove depends on CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130223072538.GA4770@www.outflux.net>
References: <20130223072538.GA4770@www.outflux.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 23 Feb 2013 10:54:45 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>
Date: Fri, 22 Feb 2013 23:25:38 -0800

> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Applied.
