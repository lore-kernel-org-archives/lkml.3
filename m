Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbaLFFbl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:31:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60299 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaLFFbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:31:39 -0500
Date: Fri, 05 Dec 2014 21:36:08 -0800 (PST)
Message-Id: <20141205.213608.2021435677853280312.davem@davemloft.net>
To: yamada.m@jp.panasonic.com
Cc: netdev@vger.kernel.org, stephen@networkplumber.org,
        gregkh@linuxfoundation.org, ast@plumgrid.com, piotr.krol@3mdeb.com,
        akpm@linux-foundation.org, sakari.ailus@linux.intel.com,
        linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uapi: fix to export linux/vm_sockets.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417396577-32499-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1417396577-32499-1-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:31:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masahiro Yamada <yamada.m@jp.panasonic.com>
Date: Mon,  1 Dec 2014 10:16:17 +0900

> A typo "header=y" was introduced by commit 7071cf7fc435
> (uapi: add missing network related headers to kbuild).
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>

Applied.
