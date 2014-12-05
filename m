Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaLEIEa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 03:04:30 -0500
Received: from mout.web.de ([212.227.17.11]:63661 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaLEIE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 03:04:28 -0500
Message-ID: <54816700.6090501@users.sourceforge.net>
Date: Fri, 05 Dec 2014 09:04:16 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by pr_warn()
 in mppe_rekey()
References: <5307CAA2.8060406@users.sourceforge.net>  <530B5FB6.6010207@users.sourceforge.net>  <alpine.DEB.2.10.1402241710370.2074@hadrien>  <530C5E18.1020800@users.sourceforge.net>  <alpine.DEB.2.10.1402251014170.2080@hadrien>  <530CD2C4.4050903@users.sourceforge.net>  <alpine.DEB.2.10.1402251840450.7035@hadrien>  <530CF8FF.8080600@users.sourceforge.net>  <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>  <530DD06F.4090703@users.sourceforge.net>  <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>  <5317A59D.4@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>  <547C82A6.2030808@users.sourceforge.net>  <547CA157.1080401@cogentembedded.com>  <5480DA32.8000201@users.sourceforge.net>  <5480DBDE.7040604@users.sourceforge.net>  <1417731809.2721.17.camel@perches.com>  <5480DFB5.4090708@users.sourceforge.net> <1417733101.2721.20.camel@perches.com> <alpine.DEB.2.02.1412050726000.2059@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1412050726000.2059@localhost6.localdomain6>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:cU57L4/WGsmYN9G0YLIEQn5PuLpRnzyabv+O0H+ip8lW4v7nGTN
 vEQ+9m1i17DvQAXIpTdMOhqBAuTfIfKZ1B7M9mJ4igQcWRPUt/Otw9dzfxF/IjvlkY+ilUU
 TGF4DVk6AKT90WSby7oop9QYjafZX9mfBF3T/guJyzAcDG9q9lbAZ2YroVXiUP2Q0iq1GCD
 GL5sr1SG+l+kIdwwLyCSw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Markus, are you sure that you cannot use netdev_warn in this case?

No. - I did not become familiar enough with the software infrastructure around
the mppe_rekey() function.

I do not see so far how I could determine a pointer for the first parameter there.
The data structure "ppp_mppe_state" (which is referenced by the input variable
"state") does not contain corresponding context information, does it?

Regards,
Markus
