Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbaKUMV6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:21:58 -0500
Received: from mout.web.de ([212.227.17.11]:55592 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaKUMV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:21:57 -0500
Message-ID: <546F2E50.5040804@users.sourceforge.net>
Date: Fri, 21 Nov 2014 13:21:36 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andreas Noever <andreas.noever@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: thunderbolt: Deletion of unnecessary checks before the function
 call "ring_free"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546F16A5.8030405@users.sourceforge.net> <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>
In-Reply-To: <CAMxnaaVLhKHjbzUJy5p_0n8BUprzSQ=A3sdF6iQzW_wqmq8N4A@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zgSKYCkEEvOdKvYZSlx3sXQk6fF9kXr9X3vnRMTkcIu81iXvZj3
 facKKWJ1cRiBfMVltOBBXGWIBD99E/9w7dKhSu3z+e+9uUzQuKAJ/2yO5A/cih/QBtsYPER
 yfNZ+2/arTrlSVa7br9Tv2X7y5FPKceyH8coyjVtnvx5mEuRwZ/404vNJHjEot114/nBq9M
 08bOoc+49Nr4L4oTZvIhA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ring_free does not check for null:
> http://lxr.free-electrons.com/source/drivers/thunderbolt/nhi.c#L398
> 
> Maybe your software confuses the method with:
> http://lxr.free-electrons.com/source/drivers/char/tpm/xen-tpmfront.c#L268

Thanks for your feedback.

I am sorry for a bit of confusion here.

1. Would it make sense that a variant for the thunderbolt ring_free()
   function will also perform input parameter validation?

2. Are any additional prefixes appropriate so that further name space
   conflicts can be better avoided?

Regards,
Markus
