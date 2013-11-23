Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab3KWWju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 17:39:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60810 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab3KWWjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 17:39:48 -0500
Date: Sat, 23 Nov 2013 14:48:18 -0800 (PST)
Message-Id: <20131123.144818.2246886107340272240.davem@davemloft.net>
To: ghorbel@pivasoftware.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ou.ghorbel@gmail.com
Subject: Re: [PATCH] sit: generate icmpv6 error when receiving icmpv4 error
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385133800-1562-1-git-send-email-ghorbel@pivasoftware.com>
References: <1385133800-1562-1-git-send-email-ghorbel@pivasoftware.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 23 Nov 2013 14:39:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oussama Ghorbel <ghorbel@pivasoftware.com>
Date: Fri, 22 Nov 2013 16:23:20 +0100

> Send icmpv6 error with type "destination unreachable" and code
> "address unreachable" when receiving icmpv4 error and sufficient
> data bytes are available
> This patch enhances the compliance of sit tunnel with section 3.4 of
> rfc 4213
> 
> Signed-off-by: Oussama Ghorbel <ghorbel@pivasoftware.com>

Applied.
