Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab3EHTFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 15:05:42 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:16173 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942Ab3EHTFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 15:05:41 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18dkMNrrDwIeS9UTxcJDjD3
Date: Wed, 8 May 2013 12:05:34 -0700
From: Tony Lindgren <tony@atomide.com>
To: Christoph Lameter <cl@linux.com>
Cc: Chris Mason <chris.mason@fusionio.com>, Pekka Enberg <penberg@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] SLAB changes for v3.10
Message-ID: <20130508190534.GA32546@atomide.com>
References: <alpine.LFD.2.03.1305070936320.2383@kernel.org>
 <20130508003022.GS28721@atomide.com>
 <20130508042422.GU28721@atomide.com>
 <20130508181353.23991.17852@localhost.localdomain>
 <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013e856463fa-9a895b58-ef76-42fa-a33d-778b89f97cf2-000000@email.amazonses.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Christoph Lameter <cl@linux.com> [130508 11:31]:
> On Wed, 8 May 2013, Chris Mason wrote:
> 
> > This patch fixes things for me, but to maintain the rules from
> > Christoph's patch,  kmalloc_caches[2] should have been created whenever
> > kmalloc_caches[7] was done.
> 
> Not necessary. The early slab bootstrap must create some slab caches of
> specific sizes, it will only use those during very early bootstrap.
> 
> The later creation of the array must skip those.
> 
> You correctly moved the checks out of the if (!kmalloc_cacheS())
> condition so that the caches are created properly.
> 
> Acked-by: Christoph Lameter <cl@linux.com>

Great this fixes things for me too:

Acked-by: Tony Lindgren <tony@atomide.com> 
