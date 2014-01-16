Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaAPQpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:45:51 -0500
Received: from qmta08.emeryville.ca.mail.comcast.net ([76.96.30.80]:36257 "EHLO
	qmta08.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752359AbaAPQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:45:49 -0500
Date: Thu, 16 Jan 2014 10:45:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 2/9] mm: slub: abstract out double cmpxchg option
In-Reply-To: <52D5AEF7.6020707@sr71.net>
Message-ID: <alpine.DEB.2.10.1401161045180.29778@nuc>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180046.C897727E@viggo.jf.intel.com> <alpine.DEB.2.10.1401141346310.19618@nuc> <52D5AEF7.6020707@sr71.net>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> On 01/14/2014 11:49 AM, Christoph Lameter wrote:
> > On Tue, 14 Jan 2014, Dave Hansen wrote:
> >> I found this useful to have in my testing.  I would like to have
> >> it available for a bit, at least until other folks have had a
> >> chance to do some testing with it.
> >
> > I dont really see the point of this patch since we already have
> > CONFIG_HAVE_ALIGNED_STRUCT_PAGE to play with.
>
> With the current code, if you wanted to turn off the double-cmpxchg abd
> get a 56-byte 'struct page' how would you do it?  Can you do it with a
> .config, or do you need to hack the code?

Remove HAVE_ALIGNED_STRUCT_PAGE from a Kconfig file.

