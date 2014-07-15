Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934374AbaGOXSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:18:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45482 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934040AbaGOXSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:18:46 -0400
Date: Tue, 15 Jul 2014 16:18:45 -0700 (PDT)
Message-Id: <20140715.161845.1295415001028350512.davem@davemloft.net>
To: teg@jklm.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 2/4] net: set name assign type for renamed devices
From: David Miller <davem@davemloft.net>
In-Reply-To: <1405348645-1995-2-git-send-email-teg@jklm.no>
References: <1405348645-1995-1-git-send-email-teg@jklm.no>
	<1405348645-1995-2-git-send-email-teg@jklm.no>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Jul 2014 16:18:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Mon, 14 Jul 2014 16:37:23 +0200

> Based on a patch from David Herrmann.
> 
> This is the only place devices can be renamed.
> 
> v9: restore revers-christmas-tree order of local variables
> 
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>

Applied.
