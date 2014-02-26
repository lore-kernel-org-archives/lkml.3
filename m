Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540AbaBZUu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:50:28 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40860 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094AbaBZUu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:50:27 -0500
Date: Wed, 26 Feb 2014 15:50:24 -0500 (EST)
Message-Id: <20140226.155024.719059614598164102.davem@davemloft.net>
To: joe@perches.com
Cc: jeffrey.t.kirsher@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Intel nic drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1393364153.8716.63.camel@joe-AO722>
References: <1393364153.8716.63.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2014 12:50:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 25 Feb 2014 13:35:53 -0800

> Add a new F: line for the intel subdirectories.
> 
> This allows get_maintainers to avoid using git log
> and cc'ing people that have submitted clean-up style
> patches for all first level directories under
> drivers/net/ethernet/intel/
> 
> This does not make e100.c maintained.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
