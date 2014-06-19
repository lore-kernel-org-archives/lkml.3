Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbaFSOhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 10:37:19 -0400
Received: from qmta05.emeryville.ca.mail.comcast.net ([76.96.30.48]:37172 "EHLO
	qmta05.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756624AbaFSOhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 10:37:17 -0400
Date: Thu, 19 Jun 2014 09:37:14 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: David Rientjes <rientjes@google.com>
cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Pekka Enberg <penberg@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: slab.h: wrap the whole file with guarding macro
In-Reply-To: <alpine.DEB.2.02.1406190213070.13670@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.11.1406190936270.2785@gentwo.org>
References: <1403100695-1350-1-git-send-email-a.ryabinin@samsung.com> <alpine.DEB.2.02.1406181321010.10339@chino.kir.corp.google.com> <53A29158.2050809@samsung.com> <alpine.DEB.2.02.1406190213070.13670@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Jun 2014, David Rientjes wrote:

> On Thu, 19 Jun 2014, Andrey Ryabinin wrote:
>
> > I had to do some modifications in this file for some reasons, and for me it was hard to not
> > notice lack of endif in the end.
> >
>
> Ok, cool, I don't think there's any need for a stable backport in that
> case.  Thanks for fixing it!

mm/slab.h is only included by mm/sl?b*.c so there is actually no effect.
