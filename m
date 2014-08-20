Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaHTDcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 23:32:32 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:52691 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaHTDca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 23:32:30 -0400
Message-ID: <1408505546.5540.25.camel@marge.simpson.net>
Subject: Re: [PATCH] [RFC] TAINT_PERFORMANCE
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com, peterz@infradead.org, mingo@redhat.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        akpm@linux-foundation.org, cl@linux.com, penberg@kernel.org,
        linux-mm@kvack.org
Date: Wed, 20 Aug 2014 05:32:26 +0200
In-Reply-To: <20140819222621.GA32690@node.dhcp.inet.fi>
References: <20140819212604.6C94DF09@viggo.jf.intel.com>
	 <20140819222621.GA32690@node.dhcp.inet.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 01:26 +0300, Kirill A. Shutemov wrote: 
> On Tue, Aug 19, 2014 at 02:26:04PM -0700, Dave Hansen wrote:

> > +	TAINT_PERF_IF(SCHEDSTATS);
> 
> Is SCHEDSTATS really harmful?

If your config is minimalist, a tad.  If your config is.. Rubenesque
(distro), you probably won't notice the extra beauty.

> It's enabled in some distro kernels.
> At least in Arch:
> 
> https://projects.archlinux.org/svntogit/packages.git/tree/trunk/config.x86_64?h=packages/linux

Ditto for SUSE.

-Mike


