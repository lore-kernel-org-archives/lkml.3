Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaGAG4A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 02:56:00 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:47258 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905AbaGAGz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 02:55:59 -0400
Date: Tue, 1 Jul 2014 08:55:55 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: hskinnemoen@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove memory start and memory end
Message-ID: <20140701065554.GA20782@samfundet.no>
References: <1404183899-5953-1-git-send-email-xerofoify@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404183899-5953-1-git-send-email-xerofoify@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 30 Jun 2014 23:04:59 -0400 or thereabout, Nicholas Krause wrote:
> This patch removes the uneeded variables memory start and memory
> stated in FIXME message before declaring this variables as extern
> unsigned longs.

Thanks for cleaning, I will append it to my for-linus branch. Queuing it for
3.17 most likely.

> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/include/asm/page.h | 3 ---
>  1 file changed, 3 deletions(-)

<snipp diff>

-- 
mvh
Hans-Christian Egtvedt
