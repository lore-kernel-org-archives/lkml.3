Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934010AbaEFDLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:11:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35930 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818AbaEFDLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:11:42 -0400
Date: Mon, 05 May 2014 23:11:40 -0400 (EDT)
Message-Id: <20140505.231140.2172378266544060318.davem@davemloft.net>
To: andi@firstfloor.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com, ak@linux.intel.com
Subject: Re: [PATCH 09/24] net, diet: Make ethtool optional
From: David Miller <davem@davemloft.net>
In-Reply-To: <1399328773-6531-10-git-send-email-andi@firstfloor.org>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
	<1399328773-6531-10-git-send-email-andi@firstfloor.org>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:11:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <andi@firstfloor.org>
Date: Mon,  5 May 2014 15:25:58 -0700

> Small embedded systems don't need ethtool, so make it optional.

You can't do anything non-trivial with an ethernet device without
ethtool.

I am not applying this.
