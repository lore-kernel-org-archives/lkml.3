Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaIZHbb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 03:31:31 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:61289 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbaIZHb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 03:31:29 -0400
Date: Fri, 26 Sep 2014 00:31:23 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au, mhocko@suse.cz
Subject: Re: mmotm 2014-09-25-16-28 uploaded
Message-ID: <20140926073123.GA3033@roeck-us.net>
References: <5424a53b.o+nym6SX0Tg7EdW6%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5424a53b.o+nym6SX0Tg7EdW6%akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 04:28:59PM -0700, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-09-25-16-28 has been uploaded to
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

Build results:
	total: 133 pass: 10 fail: 123

I won't list all the broken builds.

problem is due to

include/linux/signal.h: In function 'sigisemptyset':
include/linux/signal.h:79:3: error: implicit declaration of function 'BUILD_BUG'

as far as I can see.

Detailed build results are available at http://server.roeck-us.net:8010/builders.

Guenter
