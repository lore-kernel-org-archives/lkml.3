Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbaJRDxJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 23:53:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44377 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaJRDxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 23:53:08 -0400
Date: Fri, 17 Oct 2014 23:53:06 -0400 (EDT)
Message-Id: <20141017.235306.1730362397266264434.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, ralf@linux-mips.org,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] netrom: use linux/uaccess.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413576023-26717-1-git-send-email-fabf@skynet.be>
References: <1413576023-26717-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Oct 2014 20:53:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Fri, 17 Oct 2014 22:00:22 +0200

> replace asm/uaccess.h by linux/uaccess.h
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
