Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab3E0Jlw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:41:52 -0400
Received: from gate.crashing.org ([63.228.1.57]:38380 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab3E0Jlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:41:50 -0400
Message-ID: <1369647565.3557.28.camel@pasglop>
Subject: Re: [PATCH 1/2] ARM: kirkwood: proper retain MAC address workaround
 on DT ethernet
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: sebastian.hesselbarth@gmail.com, buytenh@wantstofly.org,
        jason@lakedaemon.net, andrew@lunn.ch, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org
Date: Mon, 27 May 2013 19:39:25 +1000
In-Reply-To: <20130527.022339.791886107453761860.davem@davemloft.net>
References: <1369253042-15082-1-git-send-email-sebastian.hesselbarth@gmail.com>
	 <20130525.210441.818472895703230779.davem@davemloft.net>
	 <51A26B62.4050009@gmail.com>
	 <20130527.022339.791886107453761860.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 02:23 -0700, David Miller wrote:
> Sparc has an of_set_property(), it needs to become generic.

There is an of_update_property(), we could change the name though, yours
is nicer :-)

Cheers,
Ben.


