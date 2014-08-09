Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751417AbaHIJOK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 05:14:10 -0400
Received: from mout.web.de ([212.227.17.11]:62564 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaHIJOE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 05:14:04 -0400
Message-ID: <53E5E656.1000606@users.sourceforge.net>
Date: Sat, 09 Aug 2014 11:13:58 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Coccinelle <cocci@systeme.lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Fabian Frederick <fabf@skynet.be>,
        Joe Perches <joe@perches.com>
Subject: Re: [patch 119/197] scripts/coccinelle/free: Delete NULL test before
 freeing functions?
References: <53e53fd1.zO3IbUqJ421c7VXf%akpm@linux-foundation.org> <53E5DA60.90902@users.sourceforge.net> <alpine.DEB.2.02.1408091028520.2016@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1408091028520.2016@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:crVygnKWByqmN0xHLgMZ0m2ZehFw2OaB3WP48Pz//Ncx/ULJXdW
 OtUQ0+ffrzqYintT8zRLL44T4SBCABCpGd+deOk5zTD7zVt3SNSa2/5mRwO0dyO92aiQf27
 7QGTgDF2OOYAqb0Jkjtt+CW7Gbzc9MJPEWcjBzxpnd46S0Vv3Fk4s5FH891t2aLJ8ttqvOK
 9BzKt7MSlCUPI+4KV6UDw==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still don't think this should be done for any random function that 
> performs a null test on its argument.  The corrections involved here are 
> not as trivial as they would seem.

I would prefer to make the list of corresponding function names more complete.


> Often it is not the case that the null test at the call site should be
> just deleted, instead the code should be reorganized.

Which source code places do you know where a different approach might look better?


> (Personally, I don't like the whole null test removal idea. [...]

Would you like to clarify involved software concerns a bit more?

Regards,
Markus
