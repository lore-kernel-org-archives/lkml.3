Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523AbaKSSuI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 13:50:08 -0500
Received: from mout.web.de ([212.227.17.11]:56458 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbaKSSuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 13:50:06 -0500
Message-ID: <546CE650.6080205@users.sourceforge.net>
Date: Wed, 19 Nov 2014 19:49:52 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: John Fastabend <john.fastabend@gmail.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: net: sched: Deletion of an unnecessary check before the function
 call "kfree"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546BAB93.4010406@users.sourceforge.net> <546CC9B3.5060405@gmail.com>
In-Reply-To: <546CC9B3.5060405@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:L+d5S/ui+7deBGL+1htKbYxAvhcWiLl+YJwrSkOXTXB8+5Pe0/D
 A77x5a9S29fbGAzgdYWJaiBB+rIvKw4tsbmlJ1IDpcz4qxnKsdN5uaWpPBpwZeN+EhwNBue
 Ykcie9KWA5SMI0/x5ExcidPgjhRObX972pKFM7k6ye2blJWAeKXE+ihys4/FlCyfk6qqYlq
 5FTqWKiBVnBxLjCx6O0IA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Marcus, what tree are you looking at?

I dared to base this update suggestion on the source files
for Linux 3.17.3. Are newer software developments relevant here?

https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/log/net/sched/

Regards,
Markus

