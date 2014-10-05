Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaJEU6L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 16:58:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54819 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaJEU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 16:57:58 -0400
Date: Sun, 05 Oct 2014 16:57:56 -0400 (EDT)
Message-Id: <20141005.165756.1863717625625011657.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz,
        sparclinux@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 09/13 linux-next] serial: sunsab: use container_of to
 resolve uart_sunsu_port from uart_port
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412528475-1449-10-git-send-email-fabf@skynet.be>
References: <1412528475-1449-1-git-send-email-fabf@skynet.be>
	<1412528475-1449-10-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Oct 2014 13:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Sun,  5 Oct 2014 19:01:10 +0200

> Use container_of instead of casting first structure member.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: David S. Miller <davem@davemloft.net>
