Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbaHWURM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 16:17:12 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:48163 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaHWURL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 16:17:11 -0400
Date: Sat, 23 Aug 2014 23:17:17 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Ganesh Rapolu <ganesh.rapolu@hotmail.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] DOCUMENTATION: Fixed typo in an example in
 memory-barriers.txt
Message-ID: <20140823201716.GA2052@p183.telecom.by>
References: <BLU436-SMTP214DCCF4135E3E81A493210E2D10@phx.gbl>
 <53F8D6DD.90306@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F8D6DD.90306@infradead.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 11:01:01AM -0700, Randy Dunlap wrote:
> On 08/22/14 23:05, Ganesh Rapolu wrote:
> > In the first example in the memory-barriers.txt file, CPU 2 is assigned to
> > run (x = B; y = A;). However, the rest of the example proceeds as if CPU 2 had been
> > running (x = A; y = B;) as shown by the descriptions of the possible executions:
> > 
> > 	STORE A=3,	STORE B=4,	x=LOAD A->3,	y=LOAD B->4
> > 	STORE A=3,	STORE B=4,	y=LOAD B->4,	x=LOAD A->3
> > 	STORE A=3,	x=LOAD A->3,	STORE B=4,	y=LOAD B->4
> > 	STORE A=3,	x=LOAD A->3,	y=LOAD B->2,	STORE B=4
> > 	STORE A=3,	y=LOAD B->2,	STORE B=4,	x=LOAD A->3
> > 	STORE A=3,	y=LOAD B->2,	x=LOAD A->3,	STORE B=4
> > 	STORE B=4,	STORE A=3,	x=LOAD A->3,	y=LOAD B->4
> > 	STORE B=4, ...
> > 	...
> > 
> > The change was merely to make the inital evironment consistent with what happens in the
> > rest of the example.

so change the rest of the example
