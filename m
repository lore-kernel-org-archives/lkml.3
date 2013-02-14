Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935097Ab3BNXVz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:21:55 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40399 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934976Ab3BNXVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:21:54 -0500
Date: Thu, 14 Feb 2013 15:21:52 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Josh Boyer <jwboyer@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) bug-fixes for v3.8-rc7
Message-ID: <20130214232152.GA3687@kroah.com>
References: <20130213205026.GA25290@phenom.dumpdata.com>
 <CA+5PVA7fzT7+O-e8ta4rU4=vLfU+DsEzvLN8-vvMm3o=8FThsg@mail.gmail.com>
 <20130214225053.GA7715@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214225053.GA7715@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 05:50:53PM -0500, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 14, 2013 at 09:18:04AM -0500, Josh Boyer wrote:
> > On Wed, Feb 13, 2013 at 3:50 PM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > >  - CVE-2013-0228/XSA-42: x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.
> > 
> > > Jan Beulich (1):
> > >       x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.
> > 
> > Should that one be CC'd to stable?
> 
> Duh. Yes it should be! Thanks for noticing it.
> 
> Greg,
> Please put git commit 13d2b4d11d69a92574a55bfd985cfb0ca77aebdc
> "x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS."
> on the stable tree.

I don't see it in Linus's tree, so there's nothing I can do until that
happens, sorry.

greg k-h
