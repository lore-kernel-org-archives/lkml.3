Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779AbaBCWkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:40:51 -0500
Received: from qmta15.westchester.pa.mail.comcast.net ([76.96.59.228]:54694
	"EHLO qmta15.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684AbaBCWks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:40:48 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Feb 2014 17:40:48 EST
Date: Mon, 3 Feb 2014 16:34:40 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@nuc
To: David Rientjes <rientjes@google.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel WARNING splat in 3.14-rc1
In-Reply-To: <alpine.DEB.2.02.1402031236250.7898@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.10.1402031634230.5527@nuc>
References: <52EFF658.2080001@lwfinger.net> <alpine.DEB.2.02.1402031236250.7898@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Feb 2014, David Rientjes wrote:

> Commit c65c1877bd68 ("slub: use lockdep_assert_held") incorrectly required
> that add_full() and remove_full() hold n->list_lock.  The lock is only
> taken when kmem_cache_debug(s), since that's the only time it actually
> does anything.

Acked-by: Christoph Lameter <cl@linux.com>
