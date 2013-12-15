Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3LOD3L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 22:29:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:53248 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LOD3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 22:29:09 -0500
Date: Sat, 14 Dec 2013 22:29:07 -0500 (EST)
Message-Id: <20131214.222907.1700289574170561336.davem@davemloft.net>
To: msalter@redhat.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 07/10] sparc: select ARCH_MIGHT_HAVE_PC_SERIO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387040376-26906-8-git-send-email-msalter@redhat.com>
References: <1387040376-26906-1-git-send-email-msalter@redhat.com>
	<1387040376-26906-8-git-send-email-msalter@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 14 Dec 2013 19:29:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Salter <msalter@redhat.com>
Date: Sat, 14 Dec 2013 11:59:33 -0500

> Architectures which might use an i8042 for serial IO to keyboard,
> mouse, etc should select ARCH_MIGHT_HAVE_PC_SERIO.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>

Acked-by: David S. Miller <davem@davemloft.net>
