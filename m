Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999AbaCLTaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:30:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40540 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaCLTaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:30:16 -0400
Date: Wed, 12 Mar 2014 15:30:14 -0400 (EDT)
Message-Id: <20140312.153014.1273454023071770387.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, jeffrey.t.kirsher@intel.com,
        jesse.brandeburg@intel.com, bruce.w.allan@intel.com,
        carolyn.wyborny@intel.com, donald.c.skidmore@intel.com,
        gregory.v.rose@intel.com, alexander.h.duyck@intel.com,
        john.ronciak@intel.com, mitch.a.williams@intel.com,
        e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 2/9] e100: Convert uses of __constant_<foo> to
 <foo>
From: David Miller <davem@davemloft.net>
In-Reply-To: <b7d59e4e50e0e90546ca66d2865d52552be1e553.1394644825.git.joe@perches.com>
References: <cover.1394644825.git.joe@perches.com>
	<b7d59e4e50e0e90546ca66d2865d52552be1e553.1394644825.git.joe@perches.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Mar 2014 12:30:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Wed, 12 Mar 2014 10:22:31 -0700

> The use of __constant_<foo> has been unnecessary for quite awhile now.
> 
> Make these uses consistent with the rest of the kernel.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Will let the Intel folks pick this up.
