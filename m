Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3JFWL0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 18:11:26 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:35393 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab3JFWLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 18:11:23 -0400
X-Originating-IP: 50.43.39.152
Date: Sun, 6 Oct 2013 15:11:16 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Preferred line-break style around binary operators?
Message-ID: <20131006221116.GR19510@leaf>
References: <20131006214829.GA20112@leaf>
 <1381096886.2081.168.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381096886.2081.168.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 06, 2013 at 03:01:26PM -0700, Joe Perches wrote:
> On Sun, 2013-10-06 at 14:48 -0700, Josh Triplett wrote:
> > There are two common approaches to breaking long lines at binary
> > operators: breaking the line before the operator (putting the operator
> > at the start of the next line), or breaking the line after the operator
> > (putting the operator at the end of the previous line).
> > 
> > CodingStyle doesn't define any requirement here, and the kernel uses
> > both approaches; for instance, using && as a sample:
> > 
> > $ git grep -h '&&$' | wc -l
> > 28872
> > $ git grep -h '^[[:space:]]*&&' | wc -l
> > 4169
> > 
> > Which style should kernel code use?  I can submit a CodingStyle patch
> > documenting that preference for future reference.
> 
> That was pretty contentious awhile ago.
> An example:
> https://lkml.org/lkml/2009/12/5/30
> 
> net/ and drivers/net/ use && and || at EOL.

It appears that the vast majority of kernel code does the same, judging
by the grep above.

Personally I prefer to put binary operators at the start of the
following line, but my preference isn't the deciding factor here.

I'd just like to see one or the other style documented as preferred in
CodingStyle for future reference, rather than having new kernel code
continue to use a mix of both styles.

- Josh Triplett
