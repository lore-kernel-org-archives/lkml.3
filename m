Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966AbbAAAVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 19:21:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47807 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbbAAAVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 19:21:42 -0500
Date: Wed, 31 Dec 2014 19:21:34 -0500 (EST)
Message-Id: <20141231.192134.2243740801309285028.davem@davemloft.net>
To: xuyongjiande@163.com
Cc: shahed.shaikh@qlogic.com, Dept-GELinuxNICDev@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xuyongjiande@gmail.com
Subject: Re: [PATCH] qlcnic: Fix return value in qlcnic_probe()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1419926626-26624-1-git-send-email-xuyongjiande@163.com>
References: <1419926626-26624-1-git-send-email-xuyongjiande@163.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Dec 2014 16:21:41 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xuyongjiande@163.com
Date: Tue, 30 Dec 2014 16:03:46 +0800

> From: Yongjian Xu <xuyongjiande@gmail.com>
> 
> If the check of adapter fails and goes into the 'else' branch, the
> return value 'err' should not still be zero.
> 
> Signed-off-by: Yongjian Xu <xuyongjiande@gmail.com>

Applied, thank you.
