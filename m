Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbaGSXDY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 19:03:24 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44771 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbaGSXDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 19:03:22 -0400
MIME-Version: 1.0
In-Reply-To: <CANZNk83yhnbw0c77UPnisaJr8AO8XtmUon78vEKGe=PBDrfWMw@mail.gmail.com>
References: <1405697638-23767-1-git-send-email-andrey.krieger.utkin@gmail.com>
	<alpine.LFD.2.11.1407182339160.2273@ja.home.ssi.bg>
	<CANZNk83dJCXAWrQ+i5rh=sdUuiiD5ZhzDua-rjJpBZCzzNGDJA@mail.gmail.com>
	<CANZNk83yhnbw0c77UPnisaJr8AO8XtmUon78vEKGe=PBDrfWMw@mail.gmail.com>
Date: Sun, 20 Jul 2014 02:03:21 +0300
Message-ID: <CANZNk83+o9Sc2rir3_2_aTgE65VadY3104a9ve8EMvXWv2ZzUg@mail.gmail.com>
Subject: Re: [PATCH 3/5] net/netfilter/ipvs/ip_vs_ctl.c: drop argument range
 check just before the check for equality
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: Julian Anastasov <ja@ssi.bg>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, dcb314@hotmail.com,
        David Miller <davem@davemloft.net>, kadlec@blackhole.kfki.hu,
        Patrick McHardy <kaber@trash.net>, pablo@netfilter.org,
        Simon Horman <horms@verge.net.au>, wensong@linux-vs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-07-20 1:59 GMT+03:00 Andrey Utkin <andrey.krieger.utkin@gmail.com>:
> This approach doesn't work, looks because sizeof() values are not
> calculated at preprocessing stage.

What about adding equivalent BUG_ON() statement to __init
ip_vs_register_nl_ioctl(), which "registers" do_ip_vs_set_ctl()
callback?

-- 
Andrey Utkin
