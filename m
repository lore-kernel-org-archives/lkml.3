Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab3DKUUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:20:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38896 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3DKUT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:19:59 -0400
Date: Thu, 11 Apr 2013 16:19:51 -0400 (EDT)
Message-Id: <20130411.161951.1231563739864529433.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        florian@openwrt.org, thomas.petazzoni@free-electrons.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: mvmdio: add clocks property to binding
 documentation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365672288-30932-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365615391-26244-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1365672288-30932-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 11 Apr 2013 13:19:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Thu, 11 Apr 2013 11:24:48 +0200

> Commit 3d604da1e9547c09c9dcc0ee443c306c9ae1a480
>   ("net: mvmdio: get and enable optional clock")
> 
> was missing an update of the corresponding device tree binding
> documentation. This patch adds the clocks property to mvmdio
> binding documentation.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Applied.
