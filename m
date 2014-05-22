Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbaEVTvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:51:00 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42115 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaEVTu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:50:58 -0400
Date: Thu, 22 May 2014 15:50:56 -0400 (EDT)
Message-Id: <20140522.155056.1319013021780564009.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: jg1.han@samsung.com, dingtianhong@huawei.com, ebiederm@xmission.com,
        Julia.Lawall@lip6.fr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] micrel: Use time_before_eq()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400781165-26498-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400781165-26498-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:50:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Thu, 22 May 2014 19:52:45 +0200

> To be future-proof and for better readability the time comparisons are modified
> to use time_before_eq() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied.
