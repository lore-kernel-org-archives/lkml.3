Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757708Ab3BFSku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 13:40:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42259 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab3BFSkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 13:40:49 -0500
Date: Wed, 06 Feb 2013 13:40:47 -0500 (EST)
Message-Id: <20130206.134047.1761684630007970885.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130206175205.GC1292@kroah.com>
References: <20130206183040.ea07a2cd64200b6d37868036@canb.auug.org.au>
	<20130206184243.c858634f5d8c3ce4ffac71f3@canb.auug.org.au>
	<20130206175205.GC1292@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Wed, 6 Feb 2013 09:52:05 -0800

> Sorry for missing this one, the fix looks correct to me, I'll queue it
> up in my tree, or it can go through David's.

It should go via your tree, my tree didn't add this regression.
