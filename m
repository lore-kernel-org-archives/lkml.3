Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab3LESqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:46:17 -0500
Received: from a9-46.smtp-out.amazonses.com ([54.240.9.46]:50392 "EHLO
	a9-46.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757141Ab3LESqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:46:14 -0500
Date: Thu, 5 Dec 2013 18:46:12 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>
Subject: Re: [PATCH 11/41] parisc: Replace __get_cpu_var uses for address
 calculation
In-Reply-To: <1386115809.2166.126.camel@dabdike.int.hansenpartnership.com>
Message-ID: <00000142c414e1b5-4ce53e2e-bc1a-44f6-971c-3a22d5e63809-000000@email.amazonses.com>
References: <20131203233232.928771708@linux.com> <20131203233250.717784556@linux.com> <1386115809.2166.126.camel@dabdike.int.hansenpartnership.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.12.05-54.240.9.46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Dec 2013, James Bottomley wrote:

> On Tue, 2013-12-03 at 17:32 -0600, Christoph Lameter wrote:
> > Convert to the use of this_cpu_ptr().
> >
> > Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
> > Cc: Helge Deller <deller@gmx.de>
> > Cc: linux-parisc@vger.kernel.org
>
> You say this in the commit, but the linux-parisc list isn't cc'd on the
> email ...

Weird my testoutput before the patchset was sent out shows that it
was included then :

>From cl@linux.com Tue Dec  3 16:11:39 2013
Message-Id: <20131203221139.732299837@linux.com>
User-Agent: quilt/0.50-1
Date: Tue, 03 Dec 2013 16:11:37 -0600
From: Christoph Lameter <cl@linux.com>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linuxfoundation.org,
 rostedt@goodmis.org,
 linux-kernel@vger.kernel.org,
 Ingo Molnar <mingo@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>,
 "James E.J. Bottomley" <jejb@parisc-linux.org>,
 Helge Deller <deller@gmx.de>,
 linux-parisc@vger.kernel.org
Subject: [PATCH 11/41] parisc: Replace __get_cpu_var uses for address calculation
References: <20131203221126.513027172@linux.com>
Content-Disposition: inline; filename=this_parisc

Convert to the use of this_cpu_ptr().

Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Christoph Lameter <cl@linux.com>


