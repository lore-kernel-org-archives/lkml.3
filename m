Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaBJTIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 14:08:04 -0500
Received: from qmta03.emeryville.ca.mail.comcast.net ([76.96.30.32]:53089 "EHLO
	qmta03.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751807AbaBJTIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:08:01 -0500
Date: Mon, 10 Feb 2014 13:07:58 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: Pekka Enberg <penberg@iki.fi>
cc: paulmck@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, penberg@kernel.org, mpm@selenic.com
Subject: Re: Memory allocator semantics
In-Reply-To: <52F60699.8010204@iki.fi>
Message-ID: <alpine.DEB.2.10.1402101304110.17517@nuc>
References: <20140102203320.GA27615@linux.vnet.ibm.com> <52F60699.8010204@iki.fi>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Feb 2014, Pekka Enberg wrote:

> So to be completely honest, I don't understand what is the race in (A) that
> concerns the *memory allocator*.  I also don't what the memory allocator can
> do in (B) and (C) which look like double-free and use-after-free,
> respectively, to me. :-)

Well it seems to be some academic mind game to me.

Does an invocation of the allocator have barrier semantics or not?




