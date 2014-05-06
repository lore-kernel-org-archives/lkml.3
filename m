Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbaEFDGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:06:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35876 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933731AbaEFDGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:06:45 -0400
Date: Mon, 05 May 2014 23:06:44 -0400 (EDT)
Message-Id: <20140505.230644.165862049328890181.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 16/24] net, diet: Make TCP fastopen optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-17-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-17-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:06:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:26:05 -0700

> Make TCP fast open a config option. It's not really needed
> on small systems. By itself it saves about 3k text,

It's for the sake of the remote service not the local client,
sorry I'm not applying this, it's a facility we want to be
ubiquitous and in widespread use on as many systems as possible.

I'm not applying this, sorry.
