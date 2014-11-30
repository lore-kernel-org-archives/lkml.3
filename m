Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146AbaK3Ukf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 15:40:35 -0500
Received: from mout.web.de ([212.227.15.4]:62174 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751650AbaK3Ukd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 15:40:33 -0500
Message-ID: <547B80B7.5030707@users.sourceforge.net>
Date: Sun, 30 Nov 2014 21:40:23 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
CC: Julia Lawall <julia.lawall@lip6.fr>, Olof Johansson <olof@lixom.net>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: net-PA Semi: Deletion of unnecessary checks before the function
 call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547A09B1.9090102@users.sourceforge.net> <547B579F.10709@gmx.de> <alpine.DEB.2.10.1411301846560.2522@hadrien> <547B6F9A.8030806@gmx.de>
In-Reply-To: <547B6F9A.8030806@gmx.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:rShwbJMSHuzuVrk7fLt7XjOMX10ZAMFry4cheik1a9hUwj8BgMh
 sNjqd7IzOEIbUCSW5FubWAtbkh6tXnzEW/wXaT7qCnR0RX8RYTeB7vY7E/dW0TRxw622SMr
 aZ8BFB0ksZJkdJ3SU17M9fYN52Y5SOKtoMHk8WSX6MZq6J2vnrniBOBd92Yj1uXQr29kCxq
 lv+6W94ciXsOrV63lNGag==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe this topic should be clarified somewhere (e.g. in "CodingStyle")?
> On the other hand i always found it obvious that its the callers
> responsibility to only pass sane parameters to the called functions...

Can you imagine that any more source code places which would benefit from
check adjustments because of defensive programming?

Regards,
Markus
