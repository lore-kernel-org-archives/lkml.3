Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbaJSUIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 16:08:46 -0400
Received: from mx1.scotdoyle.com ([23.226.141.211]:45450 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaJSUIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 16:08:45 -0400
Date: Sun, 19 Oct 2014 20:08:07 +0000 (UTC)
From: Scot Doyle <lkml14@scotdoyle.com>
To: =?ISO-8859-15?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>
cc: Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Luigi Semenzato <semenzato@google.com>,
        tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v8] tpm_tis: verify interrupt during init
In-Reply-To: <201409222101.19297.PeterHuewe@gmx.de>
Message-ID: <alpine.DEB.2.11.1410192003420.1938@localhost.localdomain>
References: <20140827214743.GC11183@obsidianresearch.com> <alpine.LNX.2.11.1409110010290.700@localhost.localdomain> <20140922171338.GB28082@obsidianresearch.com> <201409222101.19297.PeterHuewe@gmx.de>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-629582874-1413749295=:1938"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-629582874-1413749295=:1938
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Mon, 22 Sep 2014, Peter Hüwe wrote:

> Am Montag, 22. September 2014, 19:13:38 schrieb Jason Gunthorpe:
> 
> > 
> > This does look much nicer, lets use this version.
> > 
> > I think Peter were prefer a new clean patch that superceeds the
> > original.
> > 
> > > +	if (!priv->irq_tested) {
> > 
> > I think the sleep and check is still needed here, the IRQ delivery
> > could race relative to the MMIO read of completion, a sleep is the
> > only way we could attempt to synchronize them..
> > 
> 
> So will there be a v9?
> 
> Merge Window is coming up shortly, so I would like to have this sorted out 
> soon ;)
> 
> Thanks,
> Peter

Hi Peter,

The v10 patch was reviewed by Jason and is ready to go. Will you be asking 
James to pull this week?

Thanks,
Scot
--8323328-629582874-1413749295=:1938--
