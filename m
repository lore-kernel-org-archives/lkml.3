Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaKWPmp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 10:42:45 -0500
Received: from mout.web.de ([212.227.15.14]:52387 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbaKWPmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 10:42:44 -0500
Message-ID: <54720061.7010401@users.sourceforge.net>
Date: Sun, 23 Nov 2014 16:42:25 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andreas Noever <andreas.noever@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
References: <5307CAA2.8060406@users.sourceforge.net>	 <530A72AA.3000601@users.sourceforge.net>	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	 <530B5FB6.6010207@users.sourceforge.net>	 <alpine.DEB.2.10.1402241710370.2074@hadrien>	 <530C5E18.1020800@users.sourceforge.net>	 <alpine.DEB.2.10.1402251014170.2080@hadrien>	 <530CD2C4.4050903@users.sourceforge.net>	 <alpine.DEB.2.10.1402251840450.7035@hadrien>	 <530CF8FF.8080600@users.sourceforge.net>	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	 <530DD06F.4090703@users.sourceforge.net>	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	 <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>	 <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>	 <546F2E50.5040804@users.sourceforge.net>	 <1416593688.6651.39.camel@perches.com>	 <5471EBAC.40903@users.sourceforge.net> <1416756022.6651.45.camel@perches.com>
In-Reply-To: <1416756022.6651.45.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:sJO2h3l7CZXeRpr7reJeSe34ben+zqU5v7bEFIizEYWAFIXbjKb
 qrABfIlr4L6xfj99xSA7Jcuidwv58dIM7es8xpyBDc6yJ3MDVyJTupa2LtCZywz5lpE6TAK
 /E/Kj2EH4P0/LhTMzrtptzFps4IwNcPd6+h4bbUMKSt2HtLCk7FhfLjrQOka4LqCS3py7rg
 CNozSjqF2joGLscs6h/SQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/char/tpm/xen-tpmfront.c?id=fc14f9c1272f62c3e8d01300f52467c0d9af50f9#n268
> 
> I think static functions can be named whatever
> the developer chooses.

I agree also that this implementation detail is correct in principle.

Is a renaming of such identifiers feasible so that the probability of
other name clashes can be reduced and corresponding static source
code analysis might become a bit easier?

How do you prefer to handle name space issues?

Regards,
Markus
