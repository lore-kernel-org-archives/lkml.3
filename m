Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3KEXgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 18:36:54 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:61013 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3KEXgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 18:36:51 -0500
Date: Tue, 5 Nov 2013 15:36:46 -0800
From: Matt Wilson <msw@linux.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Cristian Gafton <gafton@amazon.com>,
        Anthony Liguori <anthony@codemonkey.ws>
Subject: Re: [GIT PULL] (xen) stable/for-jens-3.13
Message-ID: <20131105233646.GA25858@u109add4315675089e695.ant.amazon.com>
References: <20131105165908.GA405@phenom.dumpdata.com>
 <20131105225229.GB21473@u109add4315675089e695.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105225229.GB21473@u109add4315675089e695.ant.amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 02:52:29PM -0800, Matt Wilson wrote:
> On Tue, Nov 05, 2013 at 11:59:08AM -0500, Konrad Rzeszutek Wilk wrote:
> > 
> > Hey Jens,
> > 
> > Please git pull the following branch:
> > 
> >  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/for-jens-3.13
> > 
> > 
> > which has a fix to the Xen block frontend driver. For the backends that
> > don't support persistent grants, we don't want to use the logic that would
> > use copying (needed for persistent grants). That logic existed there initially
> > but with the persistent grants code added in - it was removed (so in 3.10
> > time-frame). This adds part of it back.
> 
> I just tested this patch as part of a backported series on top of a
> 3.4.68 base. When this patch is included and a domU boots on a system
> that does not support persistent grants the kernel panics on boot with
> the trace below. Full boot log: http://paste.ubuntu.com/6367329/
> 
> It's possible we missed something in the backport series. I'll test
> this patch on top of 3.11.4 to see how it fares.

Hi Konrad,

Looks like there's something amiss in the backport. Testing your git
branch worked fine.

Sorry for the false alarm.

--msw
