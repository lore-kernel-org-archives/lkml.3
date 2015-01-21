Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbbAULgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:36:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39928 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbbAULgJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:36:09 -0500
Date: Wed, 21 Jan 2015 13:36:05 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
Message-ID: <20150121113605.GA15292@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
 <20150115213256.GA4813@redhat.com>
 <1421397146.21318.16.camel@nilsson.home.kraxel.org>
 <1421665620.3610.13.camel@nilsson.home.kraxel.org>
 <20150120163256.GA1785@redhat.com>
 <1421839868.11160.28.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421839868.11160.28.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 12:31:08PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > > While hacking it up I've noticed spec doesn't match reality.  The
> > > "Virtio Structure PCI Capabilities" section here ...
> > > 
> > > http://docs.oasis-open.org/virtio/virtio/v1.0/cs01/virtio-v1.0-cs01.html#x1-690004
> > > 
> > > ... doesn't match what qemu is doing.  Huh?
> > 
> > Thanks a lot for the report, and the tool!
> 
> pciutils patch needs an update too (because I've made it decode the
> broken qemu capabilities).  Will come as separate mail with proper
> commit message in a moment.
> 
> > I sent patches to fix this all up.
> > You can try my qemu and linux virtio-net branches now,
> > they should be spec compliant.
> 
> Yep, much better.  caps match spec, the system boots fine from
> virtio-scsi, and the nfs-mounts (using virtio-net) are there too.
> 
> cheers,
>   Gerd


Thanks!
Want to respond to the patches with a tested-by tag?

