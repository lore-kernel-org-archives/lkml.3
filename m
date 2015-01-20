Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbbATQdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:33:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbbATQdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:33:01 -0500
Date: Tue, 20 Jan 2015 18:32:56 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
Message-ID: <20150120163256.GA1785@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
 <20150115213256.GA4813@redhat.com>
 <1421397146.21318.16.camel@nilsson.home.kraxel.org>
 <1421665620.3610.13.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421665620.3610.13.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:07:00PM +0100, Gerd Hoffmann wrote:
>   Hi,
> 
> > BTW: is there a tool (or pciutils patch) which can decode the virtio
> > capabilities?
> 
> Searched for a patch today, and all google found me was this mail asking
> for one :-o
> 
> So I went ahead and coded one up.  Attached.
> 
> While hacking it up I've noticed spec doesn't match reality.  The
> "Virtio Structure PCI Capabilities" section here ...
> 
> http://docs.oasis-open.org/virtio/virtio/v1.0/cs01/virtio-v1.0-cs01.html#x1-690004
> 
> ... doesn't match what qemu is doing.  Huh?

Thanks a lot for the report, and the tool!
I sent patches to fix this all up.
You can try my qemu and linux virtio-net branches now,
they should be spec compliant.

-- 
MST
