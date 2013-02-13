Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759328Ab3BMS5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:57:07 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43093 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab3BMS5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:57:04 -0500
Date: Wed, 13 Feb 2013 13:57:01 -0500 (EST)
Message-Id: <20130213.135701.1997724638641487624.davem@davemloft.net>
To: rientjes@google.com
Cc: torvalds@linux-foundation.org, swhiteho@redhat.com, ccaulfie@redhat.com,
        teigland@redhat.com, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org, mmarek@suse.cz, keescook@chromium.org,
        vyasevich@gmail.com
Subject: Re: [patch for-3.8] net, sctp: remove CONFIG_EXPERIMENTAL
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1302121619340.3805@chino.kir.corp.google.com>
References: <CA+55aFzCRLy5AN24rJUvbLf5HNeumn=qtS0dA9f9+2CKOLgu7A@mail.gmail.com>
	<alpine.DEB.2.02.1302121207250.25566@chino.kir.corp.google.com>
	<alpine.DEB.2.02.1302121619340.3805@chino.kir.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Rientjes <rientjes@google.com>
Date: Tue, 12 Feb 2013 16:24:56 -0800 (PST)

> From: Kees Cook <keescook@chromium.org>
> 
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> Acked-by: David S. Miller <davem@davemloft.net>
> Acked-by: Vlad Yasevich <vyasevich@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: David Rientjes <rientjes@google.com>

Applied, thanks.
