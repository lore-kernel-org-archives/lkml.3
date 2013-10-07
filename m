Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756501Ab3JGQxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 12:53:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:32820 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754335Ab3JGQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 12:53:28 -0400
Date: Mon, 07 Oct 2013 12:53:26 -0400 (EDT)
Message-Id: <20131007.125326.895480090584703586.davem@davemloft.net>
To: ou.ghorbel@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the upper MTU limit in ipv6 GRE tunnel
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380880333-3546-1-git-send-email-ou.ghorbel@gmail.com>
References: <1380880333-3546-1-git-send-email-ou.ghorbel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 07 Oct 2013 09:53:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oussama Ghorbel <ou.ghorbel@gmail.com>
Date: Fri,  4 Oct 2013 10:52:13 +0100

> Unlike ipv4, the struct member hlen holds the length of the GRE and ipv6
> headers. This length is also counted in dev->hard_header_len.
> Perhaps, it's more clean to modify the hlen to count only the GRE header
> without ipv6 header as the variable name suggest, but the simple way to fix
> this without regression risk is simply modify the calculation of the limit
> in ip6gre_tunnel_change_mtu function.
> Verified in kernel version v3.11.
> 
> Signed-off-by: Oussama Ghorbel <ou.ghorbel@gmail.com>

Please resubmit this with a proper Subject line.

It should be "[PATCH] " then a legitimate subsystem prefix.
In this case "ipv6: " would be appropriate.  And then
the "ipv6" in your existing Subject text is redundant so
can be removed.

Thanks.
