Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaANTtL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:49:11 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:51613 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274AbaANTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:49:09 -0500
Date: Tue, 14 Jan 2014 13:49:06 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [RFC][PATCH 3/9] mm: page->pfmemalloc only used by slab/skb
In-Reply-To: <20140114180051.0181E467@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1401141348130.19618@nuc>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180051.0181E467@viggo.jf.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> page->pfmemalloc does not deserve a spot in 'struct page'.  It is
> only used transiently _just_ after a page leaves the buddy
> allocator.

Why would we need to do this if we are removing the cmpxchg_double?
