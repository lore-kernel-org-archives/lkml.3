Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbaHFVfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 17:35:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43989 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754386AbaHFVfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 17:35:44 -0400
Date: Wed, 06 Aug 2014 14:35:43 -0700 (PDT)
Message-Id: <20140806.143543.1816769049569901557.davem@davemloft.net>
To: ixaphire@qrator.net
Cc: yoshfuji@linux-ipv6.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] tcp: md5: check md5 signature without socket
 lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140806224902.180d8bbee02b9f4ce82cbe5c@qrator.net>
References: <20140805025452.1a5bec4ad0d0c5a30a22a589@qrator.net>
	<20140805.162703.362629415553579077.davem@davemloft.net>
	<20140806224902.180d8bbee02b9f4ce82cbe5c@qrator.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Aug 2014 14:35:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Popov <ixaphire@qrator.net>
Date: Wed, 6 Aug 2014 22:49:02 +0400

> It seems your arguments are based on the assumption that I moved md5 signature
> check down the tcp processing chain. But I did exactly the opposite, md5 is
> checked earlier in this patch.

Ok, now I understand, thanks for explaining.

Please resubmit your patch, I'll apply it.

Thank you.
