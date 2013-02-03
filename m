Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826Ab3BCVOh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:14:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab3BCVOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:14:32 -0500
Date: Sun, 03 Feb 2013 16:14:30 -0500 (EST)
Message-Id: <20130203.161430.1661232701671861013.davem@davemloft.net>
To: khoroshilov@ispras.ru
Cc: peppe.cavallaro@st.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] stmmac: don't return zero on failure path in
 stmmac_pci_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1359756559-20211-1-git-send-email-khoroshilov@ispras.ru>
References: <1359756559-20211-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>
Date: Sat,  2 Feb 2013 02:09:19 +0400

> If stmmac_dvr_probe() fails in stmmac_pci_probe(), it breaks off initialization,
> deallocates all resources, but returns zero.
> The patch adds -ENODEV as return value in this case.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Applied to net-next, thanks.
