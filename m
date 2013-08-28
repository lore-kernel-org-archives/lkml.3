Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab3H1RQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:16:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754041Ab3H1RQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:16:04 -0400
Date: Wed, 28 Aug 2013 10:18:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Dmitry Kasatkin <d.kasatkin@samsung.com>, sedat.dilek@gmail.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: linux-next: Tree for Aug 28 [ xhci build breakage ]
Message-ID: <20130828171824.GA5012@kroah.com>
References: <CA+icZUUTBYMxLPBv2fq86h3dxyANhtpd6=Q4XGMscrntPNA9bQ@mail.gmail.com>
 <CA+icZUW6JMa6VoRJ62AUZDpYm2_q_tzSM0Ryb56RNnCdEhwQyA@mail.gmail.com>
 <CA+icZUVTzMxS4f3kZnauDkrpf4vwMbS3zd7ECOhE37S_FF83UA@mail.gmail.com>
 <CA+icZUVsG-1J2oYF+AeHsxonG2ABW4d0464yijNwaq7R5k94SQ@mail.gmail.com>
 <521DD43D.7070605@samsung.com>
 <CA+icZUWQp0k8jMqY=_DYW2Ev1cEhpev=iQNnc=NbHNgHNbifTA@mail.gmail.com>
 <521DD6BD.4030700@samsung.com>
 <20130828165938.GA26483@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828165938.GA26483@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 09:59:38AM -0700, Sarah Sharp wrote:
> Please trim your replies.
> 
> On Wed, Aug 28, 2013 at 01:53:49PM +0300, Dmitry Kasatkin wrote:
> > >>> That change seems to cause the problems:
> > >>>
> > >>> commit 0730d52a86919300a39a2be37f6c140997dfb82f
> > >>> "xhci:prevent "callbacks suppressed" when debug is not enabled"
> > >>>
> > >>> - Sedat -
> > >>>
> > >>> [1] http://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/drivers/usb/host/xhci-ring.c?h=usb-next&id=0730d52a86919300a39a2be37f6c140997dfb82f
> > >>>
> > >> Hello,
> > >>
> > >> [PATCHv2 1/2] was not applied before.
> > >> I pointed this out few hours ago...
> 
> So commit 0730d52a86919300a39a2be37f6c140997dfb82f 'xhci:prevent
> "callbacks suppressed" when debug is not enabled' needed to be applied
> after your first patch?  And basically applying that patch alone breaks
> the build?
> 
> Ugh.  Sorry about this.  Greg, how do you want to handle this?

See my other response about your pull request, how about tacking it onto
there?

thanks,

greg k-h
