Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaIXO36 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:29:58 -0400
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:41853 "EHLO
	resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752659AbaIXO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:29:55 -0400
Date: Wed, 24 Sep 2014 09:29:53 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, a.elovikov@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, slab: initialize object alignment on cache
 creation
In-Reply-To: <alpine.DEB.2.02.1409231710430.8339@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.11.1409240929240.6334@gentwo.org>
References: <20140923141940.e2d3840f31d0f8850b925cf6@linux-foundation.org> <alpine.DEB.2.02.1409231439190.22630@chino.kir.corp.google.com> <alpine.DEB.2.11.1409231821050.32451@gentwo.org> <alpine.DEB.2.02.1409231710430.8339@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, David Rientjes wrote:

> Previous to commit 4590685546a3 ("mm/sl[aou]b: Common alignment code")
> which introduced this issue.

Ah. Ok. I see and approve.

Acked-by: Christoph Lameter <cl@linux.com>

