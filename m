Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751059AbaHJDmF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 23:42:05 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57780 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714AbaHJDmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 23:42:03 -0400
Message-ID: <1407642119.5124.45.camel@marge.simpson.net>
Subject: Re: [PATCH RFC] sched: deferred set priority (dprio)
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Sergey Oboguev <oboguev.public@gmail.com>, linux-kernel@vger.kernel.org,
        khalid.aziz@oracle.com
Date: Sun, 10 Aug 2014 05:41:59 +0200
In-Reply-To: <1407640403.5124.33.camel@marge.simpson.net>
References: <8738dm9t4z.fsf@tassilo.jf.intel.com>
	 <1406532289.5133.223.camel@marge.simpson.net>
	 <CA+80gGaohO-RaG0_tWZJEFzisrrBpgfiw-mxMrTfSK0N=k7gQA@mail.gmail.com>
	 <1407059776.5156.108.camel@marge.simpson.net>
	 <CA+80gGZJGX6PjzwptNJ5gU3SvCxaYT8v4id+4NqMAPwgAAS26Q@mail.gmail.com>
	 <1407303693.5090.171.camel@marge.simpson.net>
	 <CA+80gGYUohD617FcmtD5XyrFh2ENc2nXFA=91CmZ+8zFNOrzFQ@mail.gmail.com>
	 <1407402199.5141.283.camel@marge.simpson.net>
	 <CA+80gGZWSeoHFM-_uoGFCw4nJAkQGfTjEKfSyAaqTw6xmUVMvA@mail.gmail.com>
	 <1407589454.5156.308.camel@marge.simpson.net>
	 <20140809180455.GA4120@two.firstfloor.org>
	 <1407640403.5124.33.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-08-10 at 05:13 +0200, Mike Galbraith wrote: 
> On Sat, 2014-08-09 at 20:04 +0200, Andi Kleen wrote: 
> > > NAK.  There it is, my imaginary NAK to imaginary realtime priorities :)
> > 
> > Ok, but do you have any alternative proposal yourself how to solve the
> > lockholder preemption problem? I assume you agree it's a real problem.
> > 
> > Just being negative is not very constructive.
> 
> I both acknowledged the problem problem, and made alternative
> suggestions.

Note who I replied to

https://lkml.org/lkml/2014/7/28/77

