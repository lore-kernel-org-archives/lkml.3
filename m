Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511AbaK3VQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 16:16:43 -0500
Received: from mout.web.de ([212.227.17.11]:51619 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbaK3VQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 16:16:40 -0500
Message-ID: <547B8912.7040502@users.sourceforge.net>
Date: Sun, 30 Nov 2014 22:16:02 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 3/3] net-PPP: Delete an unnecessary assignment
References: <5307CAA2.8060406@users.sourceforge.net>	 <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>	 <530A086E.8010901@users.sourceforge.net>	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>	 <530A72AA.3000601@users.sourceforge.net>	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	 <530B5FB6.6010207@users.sourceforge.net>	 <alpine.DEB.2.10.1402241710370.2074@hadrien>	 <530C5E18.1020800@users.sourceforge.net>	 <alpine.DEB.2.10.1402251014170.2080@hadrien>	 <530CD2C4.4050903@users.sourceforge.net>	 <alpine.DEB.2.10.1402251840450.7035@hadrien>	 <530CF8FF.8080600@users.sourceforge.net>	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	 <530DD06F.4090703@users.sourceforge.net>	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	 <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net>	 <547B4A35.7000500@users.sourceforge.net> <1417377583.4442.11.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1417377583.4442.11.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:DwPq+xSRSoAloX3L+ZPqEwBz219U8j3CtlW030FoLBjLGtjAH8/
 xyp4dyh/w58vXaoQxI4UYTBY3Wl7v9dkse06rmMHKCyQBpCp5QY83T7uMrGHxbbPpRLEgmM
 duWyxIYl1Rcad6+gVTwV5OXm9DdGdZkJ1cTEV75y5gI+QLDSkn6TnqB0tYkZXhA0W4HkDW/
 sAw9DFDbS9cZokjUAt+ig==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I have no idea why its a patch on its own, and why state->arc4 gets
> special treatment while state->sha1 does not.

I did not fiddle with the data structure element "sha1" because
I assumed that it might be still relevant for the call of a function
like crypto_free_blkcipher().


> This definitely belongs to the previous patch, refactoring error
> handling in mppe_alloc()

I have got different preferences for change distribution over several
patches here.
I find it safer to tackle an assignment clean-up after adjustments
for jump labels.


> Also, it seems your patches do not fix bugs, so so you need to target
> net-next tree, as explained in Documentation/networking/netdev-FAQ.txt

Do you want that I resend my update suggestion?

Regards,
Markus
