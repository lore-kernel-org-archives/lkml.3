Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab3LTAPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 19:15:13 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37033 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab3LTAPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 19:15:11 -0500
Date: Thu, 19 Dec 2013 19:15:09 -0500 (EST)
Message-Id: <20131219.191509.632527739089683539.davem@davemloft.net>
To: betty.dall@hp.com
Cc: jcliburn@gmail.com, chris.snook@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Check return from pci_find_ext_capability() in
 atl1c_reset_pcie()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1387475949-30452-1-git-send-email-betty.dall@hp.com>
References: <1387475949-30452-1-git-send-email-betty.dall@hp.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 19 Dec 2013 16:15:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Betty Dall <betty.dall@hp.com>
Date: Thu, 19 Dec 2013 10:59:09 -0700

> The function atl1c_reset_pcie() does not check the return from
> pci_find_ext_cabability() where it is getting the postion of the
> PCI_EXT_CAP_ID_ERR. It is possible for the return to be 0.
> 
> Signed-off-by: Betty Dall <betty.dall@hp.com>

Applied, thank you.
