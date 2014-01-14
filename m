Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952AbaANTtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:49:43 -0500
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:49293
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751623AbaANTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:49:40 -0500
Date: Tue, 14 Jan 2014 13:49:38 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 2/9] mm: slub: abstract out double cmpxchg option
In-Reply-To: <20140114180046.C897727E@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1401141346310.19618@nuc>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180046.C897727E@viggo.jf.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> I found this useful to have in my testing.  I would like to have
> it available for a bit, at least until other folks have had a
> chance to do some testing with it.

I dont really see the point of this patch since we already have
CONFIG_HAVE_ALIGNED_STRUCT_PAGE to play with.

