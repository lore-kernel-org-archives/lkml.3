Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaFCAB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 20:01:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37871 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756AbaFCAB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 20:01:58 -0400
Date: Mon, 02 Jun 2014 17:01:57 -0700 (PDT)
Message-Id: <20140602.170157.1949471057816808999.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: kevin.curtis@farsite.co.uk, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wan: Use usleep_range()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401548871-12352-1-git-send-email-manuel.schoelling@gmx.de>
References: <E603DC592C92B54A89CEF6B0919A0B1CAFDE223C6D@SOLO.hq.farsitecommunications.com>
	<1401548871-12352-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 02 Jun 2014 17:01:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Sat, 31 May 2014 17:07:51 +0200

> Instead of using a jiffies hack we can use the standard api for delays.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied, thanks.
