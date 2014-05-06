Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaEFUqV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:46:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43079 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaEFUqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:46:19 -0400
Date: Tue, 06 May 2014 16:46:17 -0400 (EDT)
Message-Id: <20140506.164617.2264110988048227569.davem@davemloft.net>
To: ak@linux.intel.com
Cc: richardcochran@gmail.com, josh@joshtriplett.org, andi@firstfloor.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506195049.GO19657@tassilo.jf.intel.com>
References: <20140506164108.GA20536@cloud>
	<20140506191447.GB4137@netboy>
	<20140506195049.GO19657@tassilo.jf.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 13:46:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>
Date: Tue, 6 May 2014 12:50:49 -0700

> It's still a more-features-than-your-typical-BSD TCP/IP stack

Said the guy posting patches to remove TCP metrics.
