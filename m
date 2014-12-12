Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031195AbaLLRXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 12:23:06 -0500
Received: from mout.web.de ([212.227.17.12]:58196 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030797AbaLLRXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 12:23:03 -0500
Message-ID: <548B2468.5050402@users.sourceforge.net>
Date: Fri, 12 Dec 2014 18:22:48 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
References: <548B0A29.8050503@users.sourceforge.net>	<20141212.105106.1162681032492664308.davem@davemloft.net>	<548B1E44.6050005@users.sourceforge.net> <20141212.115922.687789059853236747.davem@davemloft.net>
In-Reply-To: <20141212.115922.687789059853236747.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:x59NURkdv8XR+e43nnUr1IE6iYmaimmx2/ktlzONh9w8pUiHGeH
 AqjQH+7NJ2PRcXn7aQfB/0+W3xwA7BIYsTh119O7FPgXEkUcBtZsqiYvckGJIBgV6awAn0x
 BVZSSO3uLo7uKJHKEKfQJ9vpYMmsloFzWbBGvEnnz3oznVw3coJynYH/z60vnTupUjKu6mF
 jub41ZsG1og84CQgEwcGg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Where should "the error pointers" be stored instead?
> A local variable, before you assign it into the datastructure.

Will it be acceptable for you that anyone (or even me) will introduce
such a change with a seventh (and eventually eighth) update step here?
Do you want any other sequence for source code preparation of
the requested software improvement?

Regards,
Markus
