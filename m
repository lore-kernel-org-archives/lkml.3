Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3GKALf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 20:11:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47178 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047Ab3GKALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 20:11:33 -0400
Date: Wed, 10 Jul 2013 17:11:30 -0700 (PDT)
Message-Id: <20130710.171130.1523851475695552451.davem@davemloft.net>
To: eliezer.tamir@linux.intel.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        donald.c.skidmore@intel.com, corbet@lwn.net,
        e1000-devel@lists.sourceforge.net, eilong@broadcom.com,
        amirv@mellanox.com, erdnetdev@gmail.com, willemb@google.com,
        eliezer@tamir.org.il
Subject: Re: [PATCH net-next v3 0/3] net: finish renaming lls to busy poll
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130710141307.15596.47242.stgit@ladj378.jer.intel.com>
References: <20130710141307.15596.47242.stgit@ladj378.jer.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Date: Wed, 10 Jul 2013 17:13:07 +0300

> Here are three patches that complete the rename of lls to busy-poll
> 
> 1. rename include/net/ll_poll.h to include/net/busy_poll.h
> 2. Rename ndo_ll_poll to ndo_busy_poll.
>    Rename sk_mark_ll to sk_mark_napi_id.
>    Rename skb_mark_ll to skb_mark_napi_id.
>    Correct all useres of these functions.
>    Update comments and defines  in include/net/busy_poll.h
> 3. Rename LL_SO to BUSY_POLL_SO
>    Rename sysctl_net_ll_{read,poll} to sysctl_busy_{read,poll}
>    Fix up users of these variables.
>    Fix documentation for sysctl.
> 
> v2 fixed forgetting the ndo changes in v1
> v3 is a resend with -M

Series applied, thanks.
