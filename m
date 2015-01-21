Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbbAUOTg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 09:19:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbbAUOT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 09:19:27 -0500
Date: Wed, 21 Jan 2015 16:19:22 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v3 00/16] virtio-pci: towards virtio 1.0 guest support
Message-ID: <20150121141922.GC16206@redhat.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421356698.3933.18.camel@nilsson.home.kraxel.org>
 <20150115213256.GA4813@redhat.com>
 <1421397146.21318.16.camel@nilsson.home.kraxel.org>
 <1421665620.3610.13.camel@nilsson.home.kraxel.org>
 <20150120163256.GA1785@redhat.com>
 <1421839868.11160.28.camel@nilsson.home.kraxel.org>
 <20150121113605.GA15292@redhat.com>
 <1421847791.11160.39.camel@nilsson.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421847791.11160.39.camel@nilsson.home.kraxel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 02:43:11PM +0100, Gerd Hoffmann wrote:
> On Mi, 2015-01-21 at 13:36 +0200, Michael S. Tsirkin wrote:
> > Want to respond to the patches with a tested-by tag?
> 
> Done.
> 
> Making multiplier smaller isn't in there yet, right?
> 
> cheers,
>   Gerd

No - but I'll make sure to address this before I
post a new version.

-- 
MST
