Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3K2Vni (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 16:43:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54962 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab3K2Vnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 16:43:31 -0500
Date: Fri, 29 Nov 2013 16:43:29 -0500 (EST)
Message-Id: <20131129.164329.1281195296685567024.davem@davemloft.net>
To: puzman@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] pch_gbe fixes and enhancements
From: David Miller <davem@davemloft.net>
In-Reply-To: <1385631882-12827-1-git-send-email-puzman@gmail.com>
References: <20131127.203929.1379316258754767343.davem@davemloft.net>
	<1385631882-12827-1-git-send-email-puzman@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Nov 2013 13:43:30 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ondrej Puzman <puzman@gmail.com>
Date: Thu, 28 Nov 2013 10:44:38 +0100

> Hi,
> I'm sending the pch_gbe patch set again per David Miller's request.
> Now the patches should be correctly numbered.
> 
> The patches fixes problems I found on our industrial computer with
> Intel Atom E680T CPU and EG20T chipset.

Some of these patches are adding new features, which is not appropriate
to submit until the net-next tree is open, which it is not.

It is also not appropriate to mix bug fixes with new feature additions.

Bug fixes should be separated out and submitted targetting the
'net' tree, and then new features should be submitted targetting the
'net-next' tree but only when it is open for new changes.
