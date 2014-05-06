Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaEFROq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 13:14:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41590 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaEFROo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 13:14:44 -0400
Date: Tue, 06 May 2014 13:14:42 -0400 (EDT)
Message-Id: <20140506.131442.471106362264664281.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: josh@joshtriplett.org, andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com,
        ak@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140505.232327.578134514220748085.davem@davemloft.net>
	<20140506155703.GA20391@cloud>
	<1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 10:14:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 06 May 2014 09:39:19 -0700

> I have started using linux on 386/486 pcs which had more than 2MB of
> memory, it makes me sad we want linux-3.16 to run on this kind of
> hardware, and consuming time to save few KB here and here.

+1
