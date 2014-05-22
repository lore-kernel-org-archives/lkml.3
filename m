Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaEVTul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 15:50:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42105 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbaEVTuk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 15:50:40 -0400
Date: Thu, 22 May 2014 15:50:37 -0400 (EDT)
Message-Id: <20140522.155037.86665103961019708.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: shahed.shaikh@qlogic.com, Dept-HSGLinuxNICDev@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] qlogic: Use time_before()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400693043-15786-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400693043-15786-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 22 May 2014 12:50:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Wed, 21 May 2014 19:24:03 +0200

> To be future-proof and for better readability the time comparisons are modified
> to use time_before() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied.
