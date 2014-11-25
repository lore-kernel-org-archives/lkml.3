Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaKYT2Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:28:24 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37405 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaKYT2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:28:22 -0500
Date: Tue, 25 Nov 2014 14:28:20 -0500 (EST)
Message-Id: <20141125.142820.78809050565547546.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 01/17] new helper: skb_copy_and_csum_datagram_msg()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416924151-28698-1-git-send-email-viro@ZenIV.linux.org.uk>
References: <20141125024018.GH7996@ZenIV.linux.org.uk>
	<1416924151-28698-1-git-send-email-viro@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 25 Nov 2014 11:28:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Al, this series looks fine to me, do you have a tree I can pull
it from?
