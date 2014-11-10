Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbaKJUad (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:30:33 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48092 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaKJUab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:30:31 -0500
Date: Mon, 10 Nov 2014 15:30:29 -0500 (EST)
Message-Id: <20141110.153029.1477649870636665364.davem@davemloft.net>
To: albeu@free.fr
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, bhelgaas@google.com,
        benoit.taine@lip6.fr, ebiederm@xmission.com
Subject: Re: [PATCH 2/2] 8139too: Allow using the largest possible MTU
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415447316-12424-2-git-send-email-albeu@free.fr>
References: <1415447316-12424-1-git-send-email-albeu@free.fr>
	<1415447316-12424-2-git-send-email-albeu@free.fr>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 10 Nov 2014 12:30:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alban Bedel <albeu@free.fr>
Date: Sat,  8 Nov 2014 12:48:36 +0100

> This driver allows MTU up to 1518 bytes which is not enought to run
> batman-adv. Simply raise the maximum packet size up to the maximum
> allowed by the transmit descriptor, 1792 bytes, giving a maximum MTU
> of 1774 bytes.
> 
> Signed-off-by: Alban Bedel <albeu@free.fr>

Also applied to net-next, thanks.
