Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935751Ab3DKD1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:27:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55842 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765431Ab3DKD1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:27:32 -0400
Date: Wed, 10 Apr 2013 23:27:30 -0400 (EDT)
Message-Id: <20130410.232730.1645231962260178304.davem@davemloft.net>
To: sebastian.hesselbarth@gmail.com
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        florian@openwrt.org, thomas.petazzoni@free-electrons.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mvmdio: add clocks property to binding
 documentation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1365615391-26244-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1365615391-26244-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 10 Apr 2013 20:27:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date: Wed, 10 Apr 2013 19:36:29 +0200

> Patch "net: mvmdio: get and enable optional clock" was missing an
> update of the corresponding device tree binding documentation. This
> patch adds the clocks property to mvmdio binding documentation.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Please reference commits by SHA1 ID as well as the commit log
message header line (the latter of which should be inside
of parenthesis and double quotes).

Thanks.
