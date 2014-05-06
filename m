Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaEFUsc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:48:32 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43105 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbaEFUsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:48:31 -0400
Date: Tue, 06 May 2014 16:48:29 -0400 (EDT)
Message-Id: <20140506.164829.1457152363932527474.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ak@linux.intel.com, josh@joshtriplett.org, andi@firstfloor.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399407478.15399.81.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140506183216.GM19657@tassilo.jf.intel.com>
	<1399407478.15399.81.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 13:48:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 06 May 2014 13:17:58 -0700

> Adding ~1000 lines of code to save few KB was the point I gave up.

+1
