Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaFMUDz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 16:03:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60355 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbaFMUDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 16:03:53 -0400
Date: Fri, 13 Jun 2014 13:03:50 -0700 (PDT)
Message-Id: <20140613.130350.1729507484821351177.davem@davemloft.net>
To: mprivozn@redhat.com
Cc: jiri@resnulli.us, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net-sysfs: Report link speed only when possible
From: David Miller <davem@davemloft.net>
In-Reply-To: <539AC237.40402@redhat.com>
References: <20140606085733.GJ2984@minipsycho.orion>
	<20140606.125447.1665616708152334692.davem@davemloft.net>
	<539AC237.40402@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 13 Jun 2014 13:03:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Privoznik <mprivozn@redhat.com>
Date: Fri, 13 Jun 2014 11:19:51 +0200

> So if I were developing brand new application I could say: I'm
> dropping all this workaround code and have it clean and require say
> 3.16 kernel at least.

Then your application wouldn't be usable on %99 of systems for a long
long time.

I don't think this is the right tradeoff at all.
