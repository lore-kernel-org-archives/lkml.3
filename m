Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379Ab3D2SE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 14:04:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59944 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757710Ab3D2SE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 14:04:27 -0400
Date: Mon, 29 Apr 2013 14:04:24 -0400 (EDT)
Message-Id: <20130429.140424.2195591601359157776.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] drivers: net: usb: pegasus: bug fixing and cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.02.1304261008410.3772@fry.nucleusys.com>
References: <alpine.DEB.2.02.1304261008410.3772@fry.nucleusys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Mon, 29 Apr 2013 11:04:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Fri, 26 Apr 2013 10:13:41 +0300 (EEST)

> From: Petko Manolov <petkan@nucleusys.com>
> 
> This series of patches is fixing a bug related to multiple control URB 
> submissions (noted by Sarah Sharp), optimizes read and write_mii_word 
> routines and removes socket buffer pool used in the receive path.
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>

Series applied, thanks.
