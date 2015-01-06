Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbbAFEK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 23:10:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37500 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbbAFEK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 23:10:56 -0500
Date: Mon, 05 Jan 2015 23:10:54 -0500 (EST)
Message-Id: <20150105.231054.790363276763745624.davem@davemloft.net>
To: fkan@apm.com
Cc: patches@apm.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] net: eth: xgene: change APM X-Gene SoC platform
 ethernet to support ACPI
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAL85gmCGK54yK3sThVhGsatMVUS8+76LRwdDt4w9PUfppMJ3og@mail.gmail.com>
References: <20150105.224137.894770670718334587.davem@davemloft.net>
	<20150105.224235.1941007145649816230.davem@davemloft.net>
	<CAL85gmCGK54yK3sThVhGsatMVUS8+76LRwdDt4w9PUfppMJ3og@mail.gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 Jan 2015 20:10:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Feng Kan <fkan@apm.com>
Date: Mon, 5 Jan 2015 20:05:28 -0800

> I see, I initially tried on the net-next tree which did not build for
> me, failed somewhere else but builds xgene enet ok.
> Then I tested on net/master which builds fine for me.
> Would you please point me to the branch you are using?

net-next
