Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3KVMxF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 07:53:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:39930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab3KVMxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 07:53:02 -0500
Date: Fri, 22 Nov 2013 12:52:57 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: James Henstridge <james.henstridge@canonical.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Fabien =?iso-8859-1?Q?Andr=E9?= <fabien.andre@gmail.com>,
        Bastien Nocera <hadess@hadess.net>
Subject: Re: [appleir] BUG: unable to handle kernel NULL pointer dereference
Message-ID: <20131122125257.GD4629@hercules.my.domain>
References: <20131029145139.GA2788@hercules>
 <alpine.LNX.2.00.1311061635160.835@pobox.suse.cz>
 <CALcaVO=jOEqCwLCMUgEkFJMcc4H6bMLU4yvjo1fJ7DeXgkZH6A@mail.gmail.com>
 <527BB695.9040209@redhat.com>
 <alpine.LNX.2.00.1311191533200.6657@pobox.suse.cz>
 <CALcaVOmCAV8XeURJ5UpWfaFXoj+bz6DZ1NgAt7Xiv5pfEynRFQ@mail.gmail.com>
 <alpine.LNX.2.00.1311210959170.22082@pobox.suse.cz>
 <20131121101316.GA3394@hercules.my.domain>
 <alpine.LNX.2.00.1311221339110.22082@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1311221339110.22082@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 01:39:47PM +0100, Jiri Kosina wrote:
> On Thu, 21 Nov 2013, Luis Henriques wrote:
> 
> > > > Sorry for the delays in testing out the patch.  I have tried a kernel
> > > > with the patch applied, and can no longer reproduce the oops.  The
> > > > hid-appleir driver appears to be working correctly, generating key
> > > > press events in response to the remote, and LIRC functions correctly
> > > > via hiddev.
> > > > 
> > > > Thanks for the everyone's help with this.
> > > 
> > > Applied, thanks.
> > 
> > Hi Jiri,
> > 
> > Since this fixes an issue in a 3.11 kernel, could you please tag this
> > commit for stable>=3.11?  If its too late, I can send the request to
> > stable@ once this patch is merged.
> 
> Thanks for noticing. It's too late to add the tag, so if you submit it to 
> -stable once it's in Linus' tree, I'll appreciate it; otherwise I'll try 
> to remember to do that myself.

Sure, no problem.  I'll keep an eye on this.

Cheers,
--
Luis
