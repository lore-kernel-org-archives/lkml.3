Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaDDOtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:49:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52191 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaDDOto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:49:44 -0400
Date: Fri, 04 Apr 2014 10:51:18 -0400 (EDT)
Message-Id: <20140404.105118.934664854528401948.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, paul.durrant@citrix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jonathan.davies@citrix.com
Subject: Re: [PATCH net-next v3 1/2] xen-netback: Rename map ops
From: David Miller <davem@davemloft.net>
In-Reply-To: <533EC612.90400@citrix.com>
References: <1396458298-30041-1-git-send-email-zoltan.kiss@citrix.com>
	<20140403.142330.1048193401278908355.davem@davemloft.net>
	<533EC612.90400@citrix.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Apr 2014 07:49:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Fri, 4 Apr 2014 15:47:46 +0100

> I still can't see these two on net-next, did something went wrong?

The net-next tree is closed, and I merged it all to Linus, therefore
changes are going into 'net' now.
