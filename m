Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaLEHTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 02:19:12 -0500
Received: from mout.web.de ([212.227.15.14]:53851 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbaLEHTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 02:19:10 -0500
Message-ID: <54815C5F.8090702@users.sourceforge.net>
Date: Fri, 05 Dec 2014 08:18:55 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 1/6] net-PPP: Replacement of a printk() call by pr_warn()
 in mppe_rekey()
References: <5307CAA2.8060406@users.sourceforge.net>	 <530B5FB6.6010207@users.sourceforge.net>	 <alpine.DEB.2.10.1402241710370.2074@hadrien>	 <530C5E18.1020800@users.sourceforge.net>	 <alpine.DEB.2.10.1402251014170.2080@hadrien>	 <530CD2C4.4050903@users.sourceforge.net>	 <alpine.DEB.2.10.1402251840450.7035@hadrien>	 <530CF8FF.8080600@users.sourceforge.net>	 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>	 <530DD06F.4090703@users.sourceforge.net>	 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>	 <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net>	 <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com>	 <547C82A6.2030808@users.sourceforge.net>	 <547CA157.1080401@cogentembedded.com>	 <5480DA32.8000201@users.sourceforge.net>	 <5480DBDE.7040604@users.sourceforge.net>	 <1417731809.2721.17.camel@perches.com>	 <5480DFB5.4090708@users.sourceforge.net> <1417733101.2721.20.camel@perches.com>
In-Reply-To: <1417733101.2721.20.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:tlOu3F0asddvgOOWuWSpbHMiZdBSQLWqLOI7FsWQQTZxiUHGwzD
 8cHqCYK80GTSQt3oeXqP09wjRRS0otRUPRPv1zmEbAFd2rQI5vECHobED2Ff2yZ8ZTcjkf1
 OT5qlr/q+iqlDY8fxcb6ik1j9ci/OPCi9MqO+FT5bHRSMghbV251GLp2nrIpQG7IA+MtrBU
 kipfr3mD35A0dCBAAvCug==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> It's generally nicer to replace embedded function names
>>> with "%s: ", __func__
>>>
>>> 			pr_warn("%s: cipher_encrypt failed\n", __func__);
>>
>> Do you want that I send a third patch series for the fine-tuning of these parameters?
> 
> If you want.

Would "a committer" fix such a small source code adjustment also without a resend of
a patch series?


> I just wanted you to be aware of it for future patches.

Thanks for your tip.

Does it make sense to express such implementation details in the Linux coding
style documentation more explicitly (besides the fact that this update suggestion
was also triggered by a warning from the script "checkpatch.pl").

Regards,
Markus
