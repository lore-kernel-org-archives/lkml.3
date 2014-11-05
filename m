Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaKEQC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:02:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:50147 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbaKEQCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:02:55 -0500
Date: Wed, 5 Nov 2014 16:02:49 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Amos Kong <akong@redhat.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, rusty@rustcorp.com.au,
        amit.shah@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16 stable PATCH 0/2] virtio-rng: two backports to fix stuck
Message-ID: <20141105160249.GG9403@hercules>
References: <1412981509-30025-1-git-send-email-akong@redhat.com>
 <20141104043227.GA13409@air.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141104043227.GA13409@air.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amos

On Tue, Nov 04, 2014 at 12:32:27PM +0800, Amos Kong wrote:
> On Sat, Oct 11, 2014 at 06:51:47AM +0800, Amos Kong wrote:
> > I received two mails about faile to apply patches to 3.16-stable tree:
> > 
> > FAILED: patch "[PATCH] virtio-rng: skip reading when we start to remove the device" failed to apply to 3.16-stable tree
> > FAILED: patch "[PATCH] virtio-rng: fix stuck of hot-unplugging busy device" failed to apply to 3.16-stable tree
> > 
> > Amit already backported two patches for 3.16-stable, then cherry-pick
> > of my two patches works.
> > 
> > Thanks.
> 
> Ping Greg, thanks.
>  

I'm now doing the extended stable maintenance of the 3.16 kernel, as
Greg has EOL'ed it.

Anyway, I will be queuing these 2 patches for the extended 3.16
kernel.  Thank you!

Cheers,
--
Luís

> > Amos Kong (2):
> >   virtio-rng: fix stuck of hot-unplugging busy device
> >   virtio-rng: skip reading when we start to remove the device
> > 
> >  drivers/char/hw_random/virtio-rng.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > -- 
> > 1.9.3
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> -- 
> 			Amos.
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
