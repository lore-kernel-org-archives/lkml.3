Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbaKWAv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 19:51:56 -0500
Received: from mout.web.de ([212.227.15.14]:64496 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940AbaKWAvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 19:51:54 -0500
Message-ID: <54712F8C.10206@users.sourceforge.net>
Date: Sun, 23 Nov 2014 01:51:24 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: net: Hyper-V: Deletion of an unnecessary check before the function
 call "vfree"
References: <546DF9D7.6080801@users.sourceforge.net>	<20141121.151503.1986113223309494197.davem@davemloft.net>	<546FB98E.5070703@users.sourceforge.net> <20141121.172705.540279259389643572.davem@davemloft.net>
In-Reply-To: <20141121.172705.540279259389643572.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:2wDw877mq7x8BHx+A7yKuJWr+sA7v229KPFj1hHMrsXUWJMRU36
 p66UCYoqaFFy3nne5TDXe8gCrDKJ0x+V1Df/GCPVjrRvbgOSBVj0Nom7nKGSl3SNlZ8YVe+
 cVb9K8thYy8WSbBcN431ywyrV43hXVnmhwtBn11QFTEhkMB7jtixCWdx4AWskMKSIBpep4I
 os11hsslhZvZV4itWDt9g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This has nothing to do with me asking you to frame your patches
> against the correct tree.

I imagine than someone other can also pick up this update suggestion
(a simple change of two lines) quicker before I might try another
software build again from a different commit as a base.

Regards,
Markus
