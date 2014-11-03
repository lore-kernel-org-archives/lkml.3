Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaKCQLQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 11:11:16 -0500
Received: from mout.web.de ([212.227.15.3]:54939 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbaKCQKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 11:10:49 -0500
Message-ID: <5457A8FB.8070306@users.sourceforge.net>
Date: Mon, 03 Nov 2014 17:10:35 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ursula Braun <ubraun@linux.vnet.ibm.com>
CC: Ursula Braun <ursula.braun@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: s390/net: Deletion of unnecessary checks before two function
 calls
References: <5307CAA2.8060406@users.sourceforge.net>	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>	 <530A086E.8010901@users.sourceforge.net>	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>	 <530A72AA.3000601@users.sourceforge.net>	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	 <530B5FB6.6010207@users.sourceforge.net>	 <alpine.DEB.2.10.1402241710370.2074@hadrien>	 <530C5E18.1020800@users.sourceforge.net>	 <alpine.DEB.2.10.1402251014170.2080@hadrien>	 <530CD2C4.4050903@users.sourceforge.net>	 <alpine.DEB.2.10.1402251840450.7035@hadrien>	 <530CF8FF.8080600@users.sourceforge.net>	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	 <530DD06F.4090703@users.sourceforge.net>	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	 <5317A59D.4@users.sourceforge.net> <5453C98C.90105@users.sourceforge.net> <1415012678.18669.6.camel@BR9GV9YG.de.ibm.com>
In-Reply-To: <1415012678.18669.6.camel@BR9GV9YG.de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:KUfywJYtsMtDbaOJVIBXy/6Orhl9tZJEaHhqXXjhig4H+p9jcRl
 6ms2GKSKK81bPPrw9s3MlmWNwnAZ7Bpbvk0xsuOVDycwZB1OVLBYWtRKoRgsH/Iv9vWUZbb
 yvLEf9qrnKYhU+6gmdz2PSpxW584Qtysj8I1PH9tJYl/sne/LbqWZ7psKi1Krx1qtBWDIsz
 b2y+PioOi0KKSlGvYf1Bg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I agree with your proposed debug_unregister() changes, but not with your
> kfree_fsm() change.

Why do you want to keep an additional null pointer check before the call
of the kfree_fsm() function within the implementation of the
netiucv_free_netdevice() function?

Regards,
Markus
