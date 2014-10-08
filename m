Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbaJHN1Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:27:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45759 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201AbaJHN1O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:27:14 -0400
Date: Wed, 8 Oct 2014 06:26:15 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Roger Quadros <rogerq@ti.com>
Cc: Oussama Ghorbel <ghorbel@pivasoftware.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Rabin Vincent <rabin@rab.in>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2] phy: omap-usb2: Enable runtime PM of omap-usb2 phy
 properly
Message-ID: <20141008132615.GA5119@kroah.com>
References: <20141006194418.GA399@debian>
 <1412679771-8293-1-git-send-email-ghorbel@pivasoftware.com>
 <5434F336.4040908@ti.com>
 <543517F9.9070109@pivasoftware.com>
 <54352340.3050900@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54352340.3050900@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 02:42:56PM +0300, Roger Quadros wrote:
> Oussama,
> 
> On 10/08/2014 01:54 PM, Oussama Ghorbel wrote:
> > Hi Roger,
> > 
> > Should I resend this v2 version of the patch to stable@vger.kernel.org which is suitable for v3.17 and which will require a very tiny adaptation?
> > Or I should resend the first version of this patch which is suitable for 3.16 but might seems confusing a little sine I'm resend the outdated version.
> 
> If it is a trivial conflict then I think you can just send the patch
> which applies to the most recent kernel.
> Greg can clarify if I'm wrong as he maintains the stable trees.

Please read Documentation/stable_kernel_rules.txt for how to submit
patches to the stable trees.  Note, it has to be in Linus's tree _first_
before you ever worry about the stable trees.  Do that first please.

thanks,

greg k-h
