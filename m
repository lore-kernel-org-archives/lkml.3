Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbaDWRKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:10:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39958 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239AbaDWRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:10:31 -0400
Message-ID: <5357F405.20205@infradead.org>
Date: Wed, 23 Apr 2014 10:10:29 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-next@vger.kernel.org,
        Luiz Capitulino <lcapitulino@redhat.com>
Subject: Re: mmotm 2014-04-22-15-20 uploaded (uml 32- and 64-bit defconfigs)
References: <20140422222121.2FAB45A431E@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20140422222121.2FAB45A431E@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/14 15:21, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-04-22-15-20 has been uploaded to
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

include/linux/hugetlb.h:468:9: error: 'HPAGE_SHIFT' undeclared (first use in this function)


-- 
~Randy
