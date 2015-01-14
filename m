Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbbANF0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 00:26:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39211 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbbANF0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 00:26:16 -0500
Date: Wed, 14 Jan 2015 00:26:14 -0500 (EST)
Message-Id: <20150114.002614.1397748285323961841.davem@davemloft.net>
To: xander.huff@ni.com
Cc: nicolas.ferre@atmel.com, jaeden.amero@ni.com, rich.tollerton@ni.com,
        ben.shelton@ni.com, brad.mouring@ni.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net/macb: improved ethtool statistics support
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421187351-27279-2-git-send-email-xander.huff@ni.com>
References: <1421187351-27279-1-git-send-email-xander.huff@ni.com>
	<1421187351-27279-2-git-send-email-xander.huff@ni.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 13 Jan 2015 21:26:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xander Huff <xander.huff@ni.com>
Date: Tue, 13 Jan 2015 16:15:51 -0600

> Currently `ethtool -S` simply returns "no stats available". It
> would be more useful to see what the various ethtool statistics
> registers' values are. This change implements get_ethtool_stats,
> get_strings, and get_sset_count functions to accomplish this.
> 
> Read all GEM statistics registers and sum them into
> macb.ethtool_stats. Add the necessary infrastructure to make this
> accessible via `ethtool -S`.
> 
> Update gem_update_stats to utilize ethtool_stats.
> 
> Signed-off-by: Xander Huff <xander.huff@ni.com>

Applied.
