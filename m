Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289Ab3FBChU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 22:37:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52802 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab3FBChS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 22:37:18 -0400
Date: Sat, 01 Jun 2013 19:37:17 -0700 (PDT)
Message-Id: <20130601.193717.2203825358470502762.davem@davemloft.net>
To: thomas@m3y3r.de
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdev: Cocci spatch "ptr_ret.spatch"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370080751.29224.37.camel@localhost.localdomain>
References: <1370080751.29224.37.camel@localhost.localdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>
Date: Sat, 01 Jun 2013 11:59:11 +0200

> 
> Signed-off-by: Thomas Meyer <thomas@m3y3r.de>

This obscure reference to the cocci path you used to find/fix
this problem is insufficient in detail for a commit log message.

You must explain exactly what the problem is, and how you fixed
it, in full sentences.   You must make your commit header lin
subject more appropriate as well.
