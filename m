Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaBQVVv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:21:51 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:51287 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390AbaBQVVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:21:49 -0500
Date: Mon, 17 Feb 2014 16:21:47 -0500 (EST)
Message-Id: <20140217.162147.705587499600284443.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: liujunliang_ljl@163.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB2NET : SR9800 : Use %zu to format size_t
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392671920-11489-1-git-send-email-geert@linux-m68k.org>
References: <1392671920-11489-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2014 13:21:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Already fixed in the net tree.
