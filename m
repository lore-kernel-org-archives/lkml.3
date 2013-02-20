Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935526Ab3BTNf6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:35:58 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:45602 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935090Ab3BTNf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:35:56 -0500
Date: Wed, 20 Feb 2013 15:35:52 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: rientjes@google.com, linux-mm@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        sparclinux@vger.kernel.org
Subject: Re: THP bug and crash on sparc64 3.8
In-Reply-To: <20130220.014137.1184382041985855584.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1302201437190.20165@math.ut.ee>
References: <20130219.143320.1413047009797673492.davem@davemloft.net> <alpine.DEB.2.02.1302191134570.790@chino.kir.corp.google.com> <20130219.144608.1425049879680985441.davem@davemloft.net> <20130220.014137.1184382041985855584.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Ok I've written an alternative version of the fix that I've been busy
> testing all evening.
> 
> I think it's much better and it's about to be posted as a series of 3
> patches.

Works much better. aptitude worked fine, as did 5 times
cp -a linux test; rm -r linux

However, "git gc" in a copy of the repository hung the machine hard, 
nothing in the logs.

3.8.0 with THP disabled can run both cp;rm and git gc several 
times without a problem.

-- 
Meelis Roos (mroos@linux.ee)
