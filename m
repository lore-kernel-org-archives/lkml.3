Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3HVCKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 22:10:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37045 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3HVCKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 22:10:34 -0400
Date: Wed, 21 Aug 2013 19:12:27 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        mathias.nyman@linux.intel.com
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
Message-ID: <20130822021227.GB1423@kroah.com>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
 <20130821184042.GC3577@xanatos>
 <CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
 <20130822004514.GB19747@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130822004514.GB19747@xanatos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 05:45:14PM -0700, Sarah Sharp wrote:
> On Wed, Aug 21, 2013 at 02:43:55PM -0700, Julius Werner wrote:
> > > Thanks for the patch!  Did you test with a USB analyzer to see if the
> > > device was actually going into USB 2.0 Link PM?  I'd like to confirm we
> > > really aren't breaking anything for DW3 hosts by enabling this.
> > 
> > Yes, I did. The LPM transfers on the analyzer look good and the device
> > works as expected.
> 
> Ok, good to know.  Greg, is your USB tree still open for feature
> requests?  I wouldn't normally send you usb-next requests so late, but
> this is pretty simple patch to extend a feature that's already in your
> usb-next tree.

Depends on how much you trust it and how bad it will break other things :)


