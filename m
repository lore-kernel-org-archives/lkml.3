Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaBCXlM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:41:12 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:57667 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbaBCXlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:41:09 -0500
Date: Mon, 3 Feb 2014 15:41:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kernel WARNING splat in 3.14-rc1
Message-ID: <20140203234105.GA10614@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <52EFF658.2080001@lwfinger.net>
 <alpine.DEB.2.02.1402031236250.7898@chino.kir.corp.google.com>
 <52F0215B.5040209@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F0215B.5040209@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020323-1344-0000-0000-0000056A352B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 05:08:11PM -0600, Larry Finger wrote:
> On 02/03/2014 02:39 PM, David Rientjes wrote:
> >Commit c65c1877bd68 ("slub: use lockdep_assert_held") incorrectly required
> >that add_full() and remove_full() hold n->list_lock.  The lock is only
> >taken when kmem_cache_debug(s), since that's the only time it actually
> >does anything.
> >
> >Require that the lock only be taken under such a condition.
> >
> >Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> >Signed-off-by: David Rientjes <rientjes@google.com>
> 
> You may add a "Tested-by: Larry Finger <Larry.Finger@lwfinger.net>".
> The patch cleans up the splat on my system. Thanks for the quick
> response.

Please feel free to add mine as well:

Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

And also feel free to ignore my patch as well.  ;-)

							Thanx, Paul

