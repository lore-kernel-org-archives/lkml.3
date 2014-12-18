Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaLRRoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:44:44 -0500
Received: from mout.web.de ([212.227.15.4]:65292 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751098AbaLRRon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:44:43 -0500
Message-ID: <54931283.1030804@users.sourceforge.net>
Date: Thu, 18 Dec 2014 18:44:35 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
References: <548B1E44.6050005@users.sourceforge.net>	<20141212.115922.687789059853236747.davem@davemloft.net>	<54930D7C.3000901@users.sourceforge.net> <20141218.122556.2148647081075440879.davem@davemloft.net>
In-Reply-To: <20141218.122556.2148647081075440879.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:AefThGopho3XJHU6YQkT9tINvP1tjt5gOb9JnWNCa3NTOFsjT1s
 XX8soOGdyZN4Bwj8mob002WdQg6sUCa7Z4u0yOL1Y15wecBbCCrGtfvkC3HgxPr+OQRi4Fu
 dupQMqGUN2jhhLaPvnRSMdWrGKVPvnpz+PDeF7zZOC9jDF9fPkeY4tUGUU7C0gvWRhcjEOx
 REm3FLWLdMbKhBoaRVlBQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Now I find still that your data reorgansisation wish can not be resolved
>> in a simple way.
> 
> I'm saying to leave the code alone.

It seems that there might be a misunderstanding between us.


> If it goes:
> 
> 	var = foo_that_returns_ptr_err()
> 	if (IS_ERR(var))
> 		return PTR_ERR(var);
> 
> 	p->bar = var;
> 
> or whatever, simply keep it that way!

A simple return was not used by the mppe_alloc() function so far because
a bit of memory clean-up will also be useful after error detection,
won't it?


> I'm not engaging in this conversation any further, you have already
> consumed way too much of my limited time on this incredibly trivial matter.

It can occasionally happen that a safe clarification of specific implementation
details will need more efforts than you would like to invest at the moment.

Regards,
Markus
