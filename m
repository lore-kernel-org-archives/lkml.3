Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3KRWNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 17:13:38 -0500
Received: from smtprelay0029.hostedemail.com ([216.40.44.29]:53666 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751544Ab3KRWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 17:13:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2565:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022
X-HE-Tag: ink59_764dcffe1d259
X-Filterd-Recvd-Size: 1851
Message-ID: <1384812810.17783.2.camel@joe-AO722>
Subject: Re: [PATCH v2 1/2] xen: vnuma support for PV guests running as domU
From: Joe Perches <joe@perches.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Elena Ufimtseva <ufimtseva@gmail.com>, xen-devel@lists.xenproject.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, akpm@linux-foundation.org, tangchen@cn.fujitsu.com,
        wency@cn.fujitsu.com, ian.campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, mukesh.rathor@oracle.com,
        linux-kernel@vger.kernel.org
Date: Mon, 18 Nov 2013 14:13:30 -0800
In-Reply-To: <528A831B.8020602@zytor.com>
References: <1384806350-12651-1-git-send-email-ufimtseva@gmail.com>
	 <1384806350-12651-2-git-send-email-ufimtseva@gmail.com>
	 <528A831B.8020602@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-11-18 at 13:14 -0800, H. Peter Anvin wrote:
> On 11/18/2013 12:25 PM, Elena Ufimtseva wrote:
> > +/* Checks if hypercall is supported */
> > +bool xen_vnuma_supported()
> 
> This isn't C++...
> http://lwn.net/Articles/487493/
> 
> There are several more things in this patchset that get flagged by
> checkpatch, but apparently this rather common (and rather serious)
> problem is still not being detected, even through a patch was submitted
> almost two years ago:
> 
> https://lkml.org/lkml/2012/3/16/510

I gave notes to the patch and no follow up was done.
https://lkml.org/lkml/2012/3/16/514



