Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933389AbaLBWfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 17:35:42 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:39430 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933065AbaLBWfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 17:35:40 -0500
Date: Tue, 2 Dec 2014 14:35:34 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202223534.GA25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141202170407.GK25340@linux.vnet.ibm.com>
 <547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
 <20141202184202.GM25340@linux.vnet.ibm.com>
 <547e0947.c332e00a.23bf.ffffa8bd@mx.google.com>
 <20141202191143.GN25340@linux.vnet.ibm.com>
 <547e11fa.8778e00a.3439.ffffa88c@mx.google.com>
 <20141202205636.GQ25340@linux.vnet.ibm.com>
 <547e36d1.c54ae00a.2571.fffffd13@mx.google.com>
 <20141202221031.GX25340@linux.vnet.ibm.com>
 <547e3aca.0ca5e00a.3c72.68f6@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547e3aca.0ca5e00a.3c72.68f6@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120222-0009-0000-0000-000006CB7863
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 08:18:46PM -0200, Dâniel Fraga wrote:
> On Tue, 2 Dec 2014 14:10:31 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Thank you!!!
> 
> 	;)
> 
> > Was this as difficult to trigger as the version with the Kconfig hack
> > that used CONFIG_PREEMPT=y and CONFIG_TREE_PREEMPT_RCU=n?
> 
> 	Yes. I had to try many times until I got the call trace.
> 
> 	I'll try the bisect as Linus suggested, but if you have any
> other suggestions, just ask ;). Thanks Paul.

Sounds good to me -- getting a single commit somewhere between
3.16 and 3.17 is going to be a lot better than reasoning indirectly
from some set of RCU read-side critical sections.  ;-)

							Thanx, Paul

