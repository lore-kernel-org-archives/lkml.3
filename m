Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbaK3T1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 14:27:33 -0500
Received: from mout.gmx.net ([212.227.17.22]:55126 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbaK3T1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 14:27:32 -0500
Message-ID: <547B6F9A.8030806@gmx.de>
Date: Sun, 30 Nov 2014 20:27:22 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: SF Markus Elfring <elfring@users.sourceforge.net>,
        Olof Johansson <olof@lixom.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/1] net-PA Semi: Deletion of unnecessary checks before
 the function call "pci_dev_put"
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547A09B1.9090102@users.sourceforge.net> <547B579F.10709@gmx.de> <alpine.DEB.2.10.1411301846560.2522@hadrien>
In-Reply-To: <alpine.DEB.2.10.1411301846560.2522@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:SeBGBVLr3aEA9O3VGEa8yGRaIwmhhO71PuuAhIrWnwDt+5cF727
 DFaZXdP+I47jQu4Z5rMUc0XWzjM5Zi6xFrL9QnVnzglEacqd5TSUbcYAVcQUlJaMhA0bgE9
 GNCASt11zl770g72qF3KC1X2PEUk66STNvqaUYSpmVnC3IAjNeORZ/Z+ONhXq4bxwbGhvRI
 hWM2a2UMRY/QiWwmTC9mw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.11.2014 18:47, Julia Lawall wrote:

> 
> I have heard of at least one case where the problem you are raising
> happened in practice...
> 
> julia

If one case is known then there are probably a lot more that have not
been discovered yet.
Maybe this topic should be clarified somewhere (e.g. in "CodingStyle")?
On the other hand i always found it obvious that its the callers
responsibility to only pass sane parameters to the called functions...

Regards,
Lino
