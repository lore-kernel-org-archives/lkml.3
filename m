Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaLPGok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 01:44:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbaLPGoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 01:44:39 -0500
Date: Mon, 15 Dec 2014 22:44:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        James Hogan <james.hogan@imgtec.com>, linux-metag@vger.kernel.org
Subject: Re: linux-next: Tree for Dec 16
Message-Id: <20141215224444.dc7f0f3c.akpm@linux-foundation.org>
In-Reply-To: <20141216063549.GA1060@roeck-us.net>
References: <20141216154622.7c2ded16@canb.auug.org.au>
	<20141216063549.GA1060@roeck-us.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Dec 2014 22:35:49 -0800 Guenter Roeck <linux@roeck-us.net> wrote:

> On Tue, Dec 16, 2014 at 03:46:22PM +1100, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add any code destined for v3.20 to your linux-next included
> > trees/branches until after v3.19-rc1 is released.
> > 
> > Changes since 20141215:
> > 
> > The infiniband tree gained a conflict against Linus' tree and a build
> > failure so I used the version from next-20141215.
> > 
> > The userns tree gained a conflict against the vfs tree.
> > 
> > The clk tree gained a build failure so I used the version from
> > next-20141215.
> > 
> > Non-merge commits (relative to Linus' tree): 3588
> >  2582 files changed, 123494 insertions(+), 135748 deletions(-)
> > 
> 
> My metag buildbot test fails with this kernel.

Thanks.  What are the error messages?

