Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933765AbaFJUkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:40:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429AbaFJUkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 16:40:17 -0400
Date: Tue, 10 Jun 2014 13:44:05 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Daniel Kiper <daniel.kiper@oracle.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3.4 82/88] xen/setup: Populate freed MFNs from non-RAM
 E820 entries and gaps to E820 RAM
Message-ID: <20140610204405.GB21390@kroah.com>
References: <20140610002424.500996570@linuxfoundation.org>
 <20140610002427.192691272@linuxfoundation.org>
 <5396CACF.6050801@citrix.com>
 <20140610093011.GL15989@olila.local.net-space.pl>
 <53970598.6090008@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53970598.6090008@citrix.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 10, 2014 at 02:18:16PM +0100, David Vrabel wrote:
> On 10/06/14 10:30, Daniel Kiper wrote:
> > On Tue, Jun 10, 2014 at 10:07:27AM +0100, David Vrabel wrote:
> >> On 10/06/14 01:25, Greg Kroah-Hartman wrote:
> >>> 3.4-stable review patch.  If anyone has any objections, please let me know.
> >>
> >> This is a new feature and not a bug fix.  I don't think it (and patches
> >> 83-85) are suitable for stable.
> > 
> > IIRC, this is the main patch fixing dom0 memory looses.
> > Earlier patches are preparatory stuff and later ones are
> > fixing bugs introduced by this patch and others. Konrad and I
> > picked only minimal set of patches to fix that issue in 3.4.
> 
> This is not a bug fix.  dom0 was previously required to use the balloon
> driver to recover memory freed during setup.  This was annoying but not
> a bug.
> 
> This patches makes significant changes to how much memory dom0 ends up.
>  Depending on hardware, the dom0_mem option, and the (non)use of the
> balloon driver  applying this could result is between 1 - 3 GB of
> additional memory allocated to dom0.  This could result in there being
> insufficient host memory available to start a VM.
> 
> Please do not add to 3.4.y.

Ok, I'll go drop these now, thanks.

greg k-h
