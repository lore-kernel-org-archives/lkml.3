Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab3GPFzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 01:55:08 -0400
Received: from plane.gmane.org ([80.91.229.3]:37900 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409Ab3GPFzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 01:55:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: ianp <snailbox88-dev@yahoo.com>
Subject: Re: Linux 3.9.10
Date: Tue, 16 Jul 2013 05:48:55 +0000 (UTC)
Message-ID: <loom.20130716T073515-564@post.gmane.org>
References: <20130713185417.GA618@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 112.205.48.49 (Mozilla/5.0 (X11; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/28.0.1500.71 Safari/537.36)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh <at> linuxfoundation.org> writes:

> Please move to the 3.10-stable series at this point in time.  If that
> isn't working for you, please let us know NOW!
> 

Hi Greg,

Unfortunate hardware owners of Intel Atom's Cedar Trail platforms (like Atom 
N2600/N2800) like myself have been relying on the excellent work of thomas001 
on the cedarview-drm kernel driver, https://github.com/thomas001/cedarview-
drm, to enable the use of the cedarview_gfx module and its proprietary, 
accelerated userspace xorg driver pvr, with later kernel releases.

Unfortunately, the 3.10 kernel release brought about some major changes in  
include/linux/proc_fs.h that prevent the successful compilation of the 
cedarview_gfx kernel module, as reported here 
https://github.com/thomas001/cedarview-drm/issues/1 .

Can you suggest how one proceeds from here? Intel cannot be relied upon to 
update the driver package, even at least the open-source cedarview-drm source 
package, for this hardware.

-ianp

