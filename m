Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935158AbaLLQ4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:56:53 -0500
Received: from mout.web.de ([212.227.15.4]:59339 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934379AbaLLQ4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:56:49 -0500
Message-ID: <548B1E44.6050005@users.sourceforge.net>
Date: Fri, 12 Dec 2014 17:56:36 +0100
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
References: <548A92E2.8090304@users.sourceforge.net>	<20141212.092950.1840808214143867233.davem@davemloft.net>	<548B0A29.8050503@users.sourceforge.net> <20141212.105106.1162681032492664308.davem@davemloft.net>
In-Reply-To: <20141212.105106.1162681032492664308.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:zIMRDmKPzIGR0PQek2yhs2Yrae5MpKN/HjjlF9+z0nJO4xXSVBU
 ddipMurI/l/BZ2etFxO2TnGjEX5psksco23xIdbp+5OFuwO7uKuAUjMrRdbuKNooUkoB03c
 NsNpsNguzElF7Wy30w1n27z48jWb4x4F+eYdh6GAW2TqttdrWTStW9W/uHHL+hud/fuIW2w
 rRN0Q54+ulqaqALgy2rmA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You are asking me to invest a lot of time for a very trivial
> set of changes.

I find the proposed six update steps also trivial so far.


> Why don't you just integrate the feedback you were given and
> resubmit your patch series, just like any other developer would?

I find the requested redesign and reorganisation of involved data structures
not so easy and therefore more challenging at the moment.
Where should "the error pointers" be stored instead?
Is such a software improvement even a kind of add-on to my patch series?

Regards,
Markus
