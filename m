Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbaEUUnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:43:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55810 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaEUUnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:43:06 -0400
Date: Wed, 21 May 2014 16:43:03 -0400 (EDT)
Message-Id: <20140521.164303.1327740853923724994.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: jdmason@kudzu.us, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH] vxge: Use time_before()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400533144-8473-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400520928.30820.23.camel@joe-AO725>
	<1400533144-8473-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 21 May 2014 13:43:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Mon, 19 May 2014 22:59:04 +0200

> To be future-proof and for better readability the time comparisons are modified
> to use time_before() instead of plain, error-prone math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied, thanks.
