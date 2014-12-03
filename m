Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbaLCLjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 06:39:08 -0500
Received: from mout.web.de ([212.227.15.4]:58824 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753343AbaLCLjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:39:05 -0500
Message-ID: <547EF64B.1080403@users.sourceforge.net>
Date: Wed, 03 Dec 2014 12:38:51 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: ALSA: ctxfi: Delete an unnecessary check before kfree()
References: <5307CAA2.8060406@users.sourceforge.net>	<alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6>	<530A086E.8010901@users.sourceforge.net>	<alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6>	<530A72AA.3000601@users.sourceforge.net>	<alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6>	<530B5FB6.6010207@users.sourceforge.net>	<alpine.DEB.2.10.1402241710370.2074@hadrien>	<530C5E18.1020800@users.sourceforge.net>	<alpine.DEB.2.10.1402251014170.2080@hadrien>	<530CD2C4.4050903@users.sourceforge.net>	<alpine.DEB.2.10.1402251840450.7035@hadrien>	<530CF8FF.8080600@users.sourceforge.net>	<alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	<530DD06F.4090703@users.sourceforge.net>	<alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	<5317A59D.4@users.sourceforge.net>	<547E2612.6010304@users.sourceforge.net> <s5hvblt6xav.wl-tiwai@suse.de>
In-Reply-To: <s5hvblt6xav.wl-tiwai@suse.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:vbNV8o+ilkbQh6LTGwJFqxDs8JrIRdFQCaSGkKN0srli0sPVNfL
 KGPOyyCN/bU0EIzup/IYxjMNUpWJdfhLjSCUCM2m6yWijqwQWWwrNOK1dydHNIEAyAR+CJh
 T1PC9YHZT8wpWVp3mPeQid+f+Hbc6fyQzg/TweOXKlTmossaE83ppGoAPbewOB65gIUmSj3
 khnhgiOCWQiRPIrKLPVsg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>   Deletion of an unnecessary check before the function call "kfree"
>>   One function call less in get_daio_rsc() after error detection
> 
> In these cases, the changes aren't so straightforward, and they don't
> improve the readability.

How do you prefer to improve the affected source code here?

Regards,
Markus

