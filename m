Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaKPQ5o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 11:57:44 -0500
Received: from mout.web.de ([212.227.15.14]:50832 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbaKPQ5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 11:57:42 -0500
Message-ID: <5468D774.60901@users.sourceforge.net>
Date: Sun, 16 Nov 2014 17:57:24 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [Cocci] [PATCH 1/1] kprobes: Deletion of an unnecessary check
 before the function call "module_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546899CF.8020808@users.sourceforge.net> <alpine.DEB.2.10.1411161428190.2364@hadrien> <5468B3FD.20409@users.sourceforge.net> <alpine.DEB.2.10.1411161639310.2364@hadrien>
In-Reply-To: <alpine.DEB.2.10.1411161639310.2364@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:Q7QUbQqLX7Fj34MZbWdfTeFc2ywf0BEKN8Vgg4jtYz9JGCYGTQ7
 7jOIPv2GN4+bN0hSDup0HGRvm4iHSRsvWsoBtr39+62lFbw4z0RQwYS6VMxeZUwGDyLnCv7
 /Fdj4XremijB7eKXbmPuGOauDJzZKsnJrbE55E4UDAKOJU2b6LMFAchJwGq4gx813S1Nh3g
 w7heIq2jPq4Kx41ei7vSw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The if around the module_put is helpful to the reader to understand
> that this possibility exists.

I have got a different opinion. I would still prefer a small code clean-up there.

Regards,
Markus

