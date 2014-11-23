Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaKWOOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 09:14:24 -0500
Received: from mout.web.de ([212.227.17.11]:51268 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaKWOOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 09:14:23 -0500
Message-ID: <5471EBAC.40903@users.sourceforge.net>
Date: Sun, 23 Nov 2014 15:14:04 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andreas Noever <andreas.noever@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
References: <5307CAA2.8060406@users.sourceforge.net>	 <530A086E.8010901@users.sourceforge.net>	 <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>	 <530A72AA.3000601@users.sourceforge.net>	 <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	 <530B5FB6.6010207@users.sourceforge.net>	 <alpine.DEB.2.10.1402241710370.2074@hadrien>	 <530C5E18.1020800@users.sourceforge.net>	 <alpine.DEB.2.10.1402251014170.2080@hadrien>	 <530CD2C4.4050903@users.sourceforge.net>	 <alpine.DEB.2.10.1402251840450.7035@hadrien>	 <530CF8FF.8080600@users.sourceforge.net>	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	 <530DD06F.4090703@users.sourceforge.net>	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	 <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net>	 <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>	 <546F2E50.5040804@users.sourceforge.net> <1416593688.6651.39.camel@perches.com>
In-Reply-To: <1416593688.6651.39.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:l3Y3/QKKkvEjyBlqkIn1kwJsIRZXr8yXXFLDbbf3EX/zcUpmiu1
 Scu/zX+nurfVHKaGU7VmDa+dj2523YwViaFrLM82jeM28lLoMRvdsmyM128yJJAHmSaf0FZ
 1VTXS8fndEmVkAgZcbEztsS6rKWFzP/R0eV2Pfqdebb9iRzuc4huXM8+JwVQuZNZtfRaPId
 GlhBSHq0EL2A5jipa5h7w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> 2. Are any additional prefixes appropriate so that further name space
>>    conflicts can be better avoided?
> 
> To avoid possible external naming conflicts, add tb_ prefix to
> various ring_<foo> structs and functions.

Do you imagine that any XEN software developers need also to reconsider
this implementation detail?
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/drivers/char/tpm/xen-tpmfront.c?id=fc14f9c1272f62c3e8d01300f52467c0d9af50f9#n268

Regards,
Markus
