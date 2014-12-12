Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760321AbaLLHCS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 02:02:18 -0500
Received: from mout.web.de ([212.227.17.11]:55245 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760260AbaLLHCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 02:02:13 -0500
Message-ID: <548A92E2.8090304@users.sourceforge.net>
Date: Fri, 12 Dec 2014 08:01:54 +0100
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
References: <547C82A6.2030808@users.sourceforge.net>	<547CA157.1080401@cogentembedded.com>	<5480DA32.8000201@users.sourceforge.net> <20141209.145447.2234157264287438778.davem@davemloft.net>
In-Reply-To: <20141209.145447.2234157264287438778.davem@davemloft.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:3SAcqwWEZupKDYz9iesrZIjgz7LLCQSVoGG8Y1zfaKFbY3fPVeP
 qAECYgxLhb4zvNhWb9LBCF72bWoOEHOTkEn6lNz9gZstmePFryKHm1TBhHpNXZwHP1aYZ9m
 dQZbjK2JesPidxly5PYqU5f0zAwzNxUr0ZHeYDsPh977Q8J/IMsf0ajb+U+0kT77raeq6tv
 ZmCvXWS3OSoohhLwyzH5A==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Generally speaking, it is advisable to not leave error pointers in data
> structures, even if they are about to be free'd up in an error path anyways.
>
> Therefore I do not like some of the patches in this series.

Can you give any more concrete feedback here?

Regards,
Markus
