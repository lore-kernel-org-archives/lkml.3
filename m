Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaAGCrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:47:12 -0500
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:46224
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754551AbaAGCrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:47:11 -0500
Date: Mon, 6 Jan 2014 20:44:47 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Dave Hansen <dave@sr71.net>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, penberg@kernel.org
Subject: Re: [PATCH] mm: slub: fix ALLOC_SLOWPATH stat
In-Reply-To: <20140106204300.DE79BA86@viggo.jf.intel.com>
Message-ID: <alpine.DEB.2.10.1401062044010.9444@nuc>
References: <20140106204300.DE79BA86@viggo.jf.intel.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014, Dave Hansen wrote:

> This patch moves stat(s, ALLOC_SLOWPATH) to be called from the
> same place that __slab_alloc() is.  This makes it much less
> likely that ALLOC_SLOWPATH will get botched again in the
> spaghetti-code inside __slab_alloc().


Acked-by: Christoph Lameter <cl@linux.com>

