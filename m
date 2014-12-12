Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934875AbaLLTIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:08:14 -0500
Received: from mail-ig0-f173.google.com ([209.85.213.173]:53496 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399AbaLLTIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:08:11 -0500
Message-ID: <1418411287.13491.22.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: David Miller <davem@davemloft.net>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Date: Fri, 12 Dec 2014 11:08:07 -0800
In-Reply-To: <548B2468.5050402@users.sourceforge.net>
References: <548B0A29.8050503@users.sourceforge.net>
	 <20141212.105106.1162681032492664308.davem@davemloft.net>
	 <548B1E44.6050005@users.sourceforge.net>
	 <20141212.115922.687789059853236747.davem@davemloft.net>
	 <548B2468.5050402@users.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-12 at 18:22 +0100, SF Markus Elfring wrote:

> Will it be acceptable for you that anyone (or even me) will introduce
> such a change with a seventh (and eventually eighth) update step here?
> Do you want any other sequence for source code preparation of
> the requested software improvement?

The thing is : We are in the merge window, tracking bugs added in latest
dev cycle.

Having to deal with patches like yours is adding pressure
on the maintainer (and other developers) at the wrong time.




