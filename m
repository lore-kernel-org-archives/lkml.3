Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbaGYHwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:52:13 -0400
Received: from ns207790.ip-94-23-215.eu ([94.23.215.26]:50714 "EHLO
	ns207790.ip-94-23-215.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756912AbaGYHwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:52:12 -0400
X-Greylist: delayed 504 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Jul 2014 03:52:12 EDT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Fri, 25 Jul 2014 10:43:46 +0300
From: =?UTF-8?Q?R=C3=A9mi_Denis-Courmont?= <remi@remlab.net>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: net, phonet, rcu: rcu hang within =?UTF-8?Q?gprs=5Fattach?=
In-Reply-To: <53D1865F.7040604@oracle.com>
References: <53D1865F.7040604@oracle.com>
Message-ID: <8427f661d1aa5707ee18596e812fd3c5@roundcube.remlab.net>
User-Agent: Roundcube Webmail/0.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Hello,

Le 2014-07-25 01:19, Sasha Levin a écrit :
> This has reproduced couple of times, and has always originated from
> gprs_attach. I don't see any obvious
> issues with the code there, so I'm not sure if it's a fault of the
> phonet or the rcu code.

Beats me :-( Is it systematic or pseudo-random?

To be honest, I do not remember how well we tested that error path way 
back when. Nevertheless gprs_detach() does basically the same thing, in 
the non-error case, and it definitely worked well as far as I could 
tell.

Maybe Phonet should be dropped though. As much as I like to have my 
name in MAINTAINERS, I have not heard of any remaining users for 
up-to-date kernel versions. And with Broadcom shutting down what was 
Nokia Wireless Modems, I doubt we will see new users ever.

-- 
Rémi Denis-Courmont
