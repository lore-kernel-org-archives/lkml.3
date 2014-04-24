Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911AbaDXWkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 18:40:41 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41384 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaDXWkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 18:40:36 -0400
Message-ID: <535992DD.3060808@infradead.org>
Date: Thu, 24 Apr 2014 15:40:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>, linux-next@vger.kernel.org,
        Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: mmotm 2014-04-24-13-07 uploaded
References: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20140424200837.727695A407C@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/14 13:08, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-04-24-13-07 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 
> mmotm-readme.txt says
> 
> README for mm-of-the-moment:
> 
> http://www.ozlabs.org/~akpm/mmotm/
> 
> This is a snapshot of my -mm patch queue.  Uploaded at random hopefully
> more than once a week.
> 
> You will need quilt to apply these patches to the latest Linus release (3.x
> or 3.x-rcY).  The series file is in broken-out.tar.gz and is duplicated in
> http://ozlabs.org/~akpm/mmotm/series
> 

uml on x86_64 defconfig:

drivers/built-in.o: In function `__handle_sysrq':
drivers/tty/sysrq.c:514: undefined reference to `rcu_sysrq_start'
drivers/tty/sysrq.c:558: undefined reference to `rcu_sysrq_end'


-- 
~Randy
