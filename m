Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934045AbaLKRFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:05:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54456 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311AbaLKRFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:05:17 -0500
Date: Thu, 11 Dec 2014 12:05:14 -0500 (EST)
Message-Id: <20141211.120514.1224165557764220263.davem@davemloft.net>
To: skhare@vmware.com
Cc: sbhatewara@vmware.com, pv-drivers@vmware.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bollar@vmware.com
Subject: Re: [PATCH] Driver: Vmxnet3: Make Rx ring 2 size configurable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1418276262-4728-1-git-send-email-skhare@vmware.com>
References: <1418276262-4728-1-git-send-email-skhare@vmware.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 09:05:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shrikrishna Khare <skhare@vmware.com>
Date: Wed, 10 Dec 2014 21:37:42 -0800

> Rx ring 2 size can be configured by adjusting rx-jumbo parameter
> of ethtool -G.
> 
> Signed-off-by: Ramya Bolla <bollar@vmware.com>
> Signed-off-by: Shreyas Bhatewara <sbhatewara@vmware.com>
> Signed-off-by: Shrikrishna Khare <skhare@vmware.com>

This is a new feature patch, and the net-next tree is closed, therefore
it is not appropriate to submit a change like this at this time.

Please resubmit when the net-next tree opens back up, some time after
the merge window is over.
