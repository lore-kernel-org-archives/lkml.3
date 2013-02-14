Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935065Ab3BNWvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 17:51:01 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23575 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759548Ab3BNWu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 17:50:59 -0500
Date: Thu, 14 Feb 2013 17:50:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Josh Boyer <jwboyer@gmail.com>, gregkh@linuxfoundation.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] (xen) bug-fixes for v3.8-rc7
Message-ID: <20130214225053.GA7715@phenom.dumpdata.com>
References: <20130213205026.GA25290@phenom.dumpdata.com>
 <CA+5PVA7fzT7+O-e8ta4rU4=vLfU+DsEzvLN8-vvMm3o=8FThsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA7fzT7+O-e8ta4rU4=vLfU+DsEzvLN8-vvMm3o=8FThsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 09:18:04AM -0500, Josh Boyer wrote:
> On Wed, Feb 13, 2013 at 3:50 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> >  - CVE-2013-0228/XSA-42: x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.
> 
> > Jan Beulich (1):
> >       x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS.
> 
> Should that one be CC'd to stable?

Duh. Yes it should be! Thanks for noticing it.

Greg,
Please put git commit 13d2b4d11d69a92574a55bfd985cfb0ca77aebdc
"x86/xen: don't assume %ds is usable in xen_iret for 32-bit PVOPS."
on the stable tree.

Thank you!
    

> 
> josh
