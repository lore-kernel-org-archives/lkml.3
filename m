Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbbAPFcL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 00:32:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:57402 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbbAPFcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 00:32:08 -0500
Date: Fri, 16 Jan 2015 00:32:06 -0500 (EST)
Message-Id: <20150116.003206.1048065414555896917.davem@davemloft.net>
To: xander.huff@ni.com
Cc: nicolas.ferre@atmel.com, david.light@aculab.com, netdev@vger.kernel.org,
        jaeden.amero@ni.com, rich.tollerton@ni.com, brad.mouring@ni.com,
        linux-kernel@vger.kernel.org, cyrille.pitchen@atmel.com
Subject: Re: [PATCH v3 3/3] net/macb: Create gem_ethtool_ops for new
 statistics functions
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421358316-23660-3-git-send-email-xander.huff@ni.com>
References: <063D6719AE5E284EB5DD2968C1650D6D1CAC999F@AcuExch.aculab.com>
	<1421358316-23660-1-git-send-email-xander.huff@ni.com>
	<1421358316-23660-3-git-send-email-xander.huff@ni.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Jan 2015 21:32:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xander Huff <xander.huff@ni.com>
Date: Thu, 15 Jan 2015 15:45:16 -0600

> 10/100 MACB does not have the same statistics possibilities as GEM. Separate
> macb_ethtool_ops to make a new GEM-specific struct with the new statistics
> functions included.
> 
> Signed-off-by: Xander Huff <xander.huff@ni.com>

Applied.
