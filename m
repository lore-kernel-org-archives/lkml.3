Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751223AbaKWHCb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 02:02:31 -0500
Received: from mout.web.de ([212.227.17.11]:51268 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbaKWHC3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 02:02:29 -0500
Message-ID: <5471864D.4070501@users.sourceforge.net>
Date: Sun, 23 Nov 2014 08:01:33 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, Haiyang Zhang <haiyangz@microsoft.com>,
        "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: net: Hyper-V: Deletion of an unnecessary check before the function
 call "vfree"
References: <546DF9D7.6080801@users.sourceforge.net>		<20141121.151503.1986113223309494197.davem@davemloft.net>		<546FB98E.5070703@users.sourceforge.net>	 <20141121.172705.540279259389643572.davem@davemloft.net>	 <54712F8C.10206@users.sourceforge.net> <1416706034.17888.9.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1416706034.17888.9.camel@edumazet-glaptop2.roam.corp.google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:C2h5Kbm4um9wjWscp0zON6C3lEOeXckmn9HKLfSFMBPm5NdVG9c
 neAx+fuUVGn7WA8dhxNtrsT/glEAbeqOWXmoEo/gRdhvWCXON1anQWu1KnG1z2ybIHt6YKb
 a5nWrT2hdtY90gv1KlCyB3vf47ieeXR7f+Y0peBEK8REwM+/3a2qrbhRLM8z41rUUH1snZB
 087OKj0H79fdNia9qPV9w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I imagine than someone other can also pick up this update suggestion
>> (a simple change of two lines) quicker before I might try another
>> software build again from a different commit as a base.
> 
> I have no idea why someone would do that.

I imagine that other software users (besides me) like developers
and testers might also become curious to try the proposed changes out.

How much will they eventually help to run Linux components a bit faster?


> If you don't bother resubmit, nobody will.

I hope that there are more possibilities for anticipation and acceptance
of source code improvement potentials.
Would you also like to contribute a bit more fine-tuning for the affected
software versions?

Regards,
Markus
