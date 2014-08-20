Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaHTADK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 20:03:10 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:41488 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647AbaHTADI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 20:03:08 -0400
Date: Tue, 19 Aug 2014 19:03:03 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Laura Abbott <lauraa@codeaurora.org>
cc: Dave Hansen <dave@sr71.net>, linux-kernel@vger.kernel.org,
        dave.hansen@linux.intel.com, peterz@infradead.org, mingo@redhat.com,
        ak@linux.intel.com, tim.c.chen@linux.intel.com,
        akpm@linux-foundation.org, penberg@kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [RFC] TAINT_PERFORMANCE
In-Reply-To: <53F3E1FE.1000508@codeaurora.org>
Message-ID: <alpine.DEB.2.11.1408191901370.21171@gentwo.org>
References: <20140819212604.6C94DF09@viggo.jf.intel.com> <53F3E1FE.1000508@codeaurora.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2014, Laura Abbott wrote:

> I nominate CONFIG_DEBUG_PAGEALLOC, CONFIG_SLUB_DEBUG,
> CONFIG_SLUB_DEBUG_ON as well since I've wasted days debugging
> supposed performance issues where those were on.

CONFIG_SLUB_DEBUG is not enabling debugging. It just includes the code to
do so at kernel bootup. Not a performance problem. CONFIG_SLUB_DEBUG_ON is
a performance issue since debugging will be on by default.

CONFIG_SLAB_DEBUG is also a performance issue since this option makes slab
run with debugging.

