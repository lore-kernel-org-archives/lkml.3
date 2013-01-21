Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab3AUEEd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2013 23:04:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33458 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab3AUEEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2013 23:04:32 -0500
Date: Sun, 20 Jan 2013 23:04:28 -0500 (EST)
Message-Id: <20130120.230428.1678269076372823495.davem@davemloft.net>
To: patrik.karlin@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers: atm: checkpatch.pl fixed coding style
 issues in eni.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358723575-8345-5-git-send-email-patrik.karlin@gmail.com>
References: <1358723575-8345-1-git-send-email-patrik.karlin@gmail.com>
	<1358723575-8345-5-git-send-email-patrik.karlin@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrik Karlin <patrik.karlin@gmail.com>
Date: Mon, 21 Jan 2013 00:12:55 +0100

> This patch fixes statement placement around if/else/for statments
> as suggested by checkpatch.pl
> 
> Signed-off-by: Patrik Kårlin <patrik.karlin@gmail.com>

This patch set is a good example of why nobody should
fix up coding style in such a robotic way in response
to codingstyle.pl complaints.

> -		    ATM_MAX_AAL5_PDU) eff = (length+3) >> 2;
> +		    ATM_MAX_AAL5_PDU) 

I bet you didn't even notice that in this change you are adding
trailing whitespace, the exact problem you fixed up for this file in a
previous patch of the series.

I really would encourage you to work on something else entirely.

Thanks.
