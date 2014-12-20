Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114AbaLTOpm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 09:45:42 -0500
Received: from mout.web.de ([212.227.17.12]:52206 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbaLTOpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 09:45:38 -0500
Message-ID: <54958B8C.7010105@users.sourceforge.net>
Date: Sat, 20 Dec 2014 15:45:32 +0100
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
X-Provags-ID: V03:K0:Iih6xBiP1APYgGOhopBWByOtU9FHNYH2/WbC+CxE3w8WqXdiKjv
 43Pq/LNxknD411czwhiOTuOQExPq3Lpbm8/PB7nPe0yo3fYbTDUXJWV6wGplLKiRYFEge0A
 09OY7bXoulCnmaRvHTPW0aYNW9g6O3HnxitDTTtRe850lurDwh7FoxEyzqu5MWzSiUj5wNW
 7bAN56iwoE0RrQUT1q6fQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm saying to leave the code alone.

Do I need to try another interpretation out for your feedback?


> If it goes:
> 
> 	var = foo_that_returns_ptr_err()
> 	if (IS_ERR(var))
> 		return PTR_ERR(var);
> 
> 	p->bar = var;
> 
> or whatever, simply keep it that way!

Do you want to express here that a data structure member should
only be set after a previous function call succeeded?



> I'm not engaging in this conversation any further, you have
> already consumed way too much of my limited time on this
> incredibly trivial matter.

I hope that you will find a bit time and patience again
to clarify affected implementation details in a safer and
unambiguous way.

Regards,
Markus
