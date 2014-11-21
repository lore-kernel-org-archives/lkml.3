Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbaKUN0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 08:26:15 -0500
Received: from mout.web.de ([212.227.15.14]:51217 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755232AbaKUN0O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 08:26:14 -0500
Message-ID: <546F3D59.2060504@users.sourceforge.net>
Date: Fri, 21 Nov 2014 14:25:45 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Eduardo Valentin <edubezval@gmail.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Subject: Re: thermal: Exynos: Deletion of unnecessary checks before two function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546F1017.5080403@users.sourceforge.net> <alpine.DEB.2.10.1411211116580.2554@hadrien>
In-Reply-To: <alpine.DEB.2.10.1411211116580.2554@hadrien>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:jrs3As7tj5MTa+SI1tTtrol7MaJUMZVlC9YU0tWZ7lmIn0enkh6
 2u3h2WqBpWUyGHHnR3yteIOkKdszVcM68PL+T+gzpODPBJCf055GL+SsA7ZORuBXANFkzoK
 U30KNb7MiA0CyOmpp6mbwJ9AodISaEXbqgrEMuiFkgb4BZJXqAKgS7TehhwLsqKnGK1OUq0
 5mVxiWM3fKEVOakq0jd1A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  	for (i = 0; i < th_zone->cool_dev_size; i++) {
>> -		if (th_zone->cool_dev[i])
>> -			cpufreq_cooling_unregister(th_zone->cool_dev[i]);
>> +		cpufreq_cooling_unregister(th_zone->cool_dev[i]);
>>  	}
> 
> Now you have unnecessary {}

How are the chances that your source code transformation tool
can also consider the deletion of curly brackets in such an use case?

Can any more pretty-printing rules be integrated from a specific
coding style configuration?

Regards,
Markus

