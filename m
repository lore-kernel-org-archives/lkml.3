Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaEFRRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:17:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41612 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEFRRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:17:53 -0400
Date: Tue, 06 May 2014 13:17:52 -0400 (EDT)
Message-Id: <20140506.131752.740569380523989782.davem@davemloft.net>
To: josh@joshtriplett.org
Cc: eric.dumazet@gmail.com, andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140506164546.GB20536@cloud>
References: <20140506155703.GA20391@cloud>
	<1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140506164546.GB20536@cloud>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 10:17:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: josh@joshtriplett.org
Date: Tue, 6 May 2014 09:45:46 -0700

> The kernel can do the same.  Consider the idea of analyzing a set of
> userspace programs, determining what kernel functionality they do and
> don't need, feeding that information into the kernel build process, and
> automatically dropping unused bits of the kernel.

Please make sure I'm not on the list of people who see reports for
bugs reported in that setup.

Thanks :-)
