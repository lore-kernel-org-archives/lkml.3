Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaKWHS6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 02:18:58 -0500
Received: from mout.web.de ([212.227.15.4]:65096 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaKWHS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 02:18:56 -0500
Message-ID: <54718A47.20301@users.sourceforge.net>
Date: Sun, 23 Nov 2014 08:18:31 +0100
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
References: <546FB98E.5070703@users.sourceforge.net>	<20141121.172705.540279259389643572.davem@davemloft.net>	<54712F8C.10206@users.sourceforge.net> <20141122.233654.279540319568229037.davem@davemloft.net>
In-Reply-To: <20141122.233654.279540319568229037.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:4kdFvR9bK+Y30UWtBRb4xmfZs5EC0ftTvTGxCe1IuJnotwW3Cr+
 d+hCppoAO1mtndTr/jU0V9Br+rDD7ftxCCMubXbe1/7e5oeWDXxws3Ywnr4vvmP8Z+Qymz1
 H4jbEYHGllEmmw+JYuFM7MoQI20oZ1Zp5dBPW8LUovan9eUnd97WqAy3qLvun2945S4bTOM
 GgV2yV6uzC0NsQs6c6xtg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Whereas if you learn how to base your changes cleanly on the correct
> base now, all of your future submissions will go quickly and smoothly
> into my tree.

My reluctance to work with more Linux repositories will evolve
over time. The faster affected software versions can be rebuilt
the more it will become interesting to try even more source
code improvements out, won't it?

I find it nice that you could accept update suggestions for
a few other Linux components already.

Regards,
Markus
