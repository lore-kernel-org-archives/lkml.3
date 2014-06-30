Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbaF3Gme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:42:34 -0400
Received: from mail1.skidata.com ([91.230.2.99]:52363 "EHLO mail1.skidata.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804AbaF3Gmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:42:33 -0400
X-Greylist: delayed 592 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jun 2014 02:42:32 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqIEAPsDsVOsEApK/2dsb2JhbABZg19axVYBgSF1hAMBAQQBOj8FCwsNCwklD0gGDgWIOg3GJxePBweEQwEEml2BR4VpkBKCLg
X-IPAS-Result: AqIEAPsDsVOsEApK/2dsb2JhbABZg19axVYBgSF1hAMBAQQBOj8FCwsNCwklD0gGDgWIOg3GJxePBweEQwEEml2BR4VpkBKCLg
Date: Mon, 30 Jun 2014 08:32:05 +0200
From: Richard Leitner <richard.leitner@skidata.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: serial: replace hardcoded ttyGS with
 PREFIX
Message-ID: <20140630083205.596557f1@lxbuild.skidata.net>
In-Reply-To: <20140627174628.GA1449@kroah.com>
References: <20140627133721.10ca6cab@lxbuild.skidata.net>
	<20140627174628.GA1449@kroah.com>
Organization: SKIDATA AG
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.60.30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
thanks for your reply!

On Fri, 27 Jun 2014 10:46:28 -0700
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> On Fri, Jun 27, 2014 at 01:37:21PM +0200, Richard Leitner wrote:
> > Replace all hardcoded ttyGS strings with the PREFIX macro.
> 
> Why?
Because IMHO if PREFIX is available it should be used everywhere possible.
Furthermore if you change the PREFIX the debug output wouldn't be consistent any more.

> 
> > Therefore the PREFIX definition is moved to u_serial.h.
> 
> Why?
Otherwise f_acm.c, f_obex.c and f_serial.c wouldn't know it.
Isn't u_serial.h the right place for it?

> 
> > Furthermore the modified files are checkpatch.pl compliant now.
> 
> You are doing two different things here in the same patch.  Please split
> it up into two different patches.
Ok, I'll do that.

> 
> thanks,
> 
> greg k-h

thanks & regards,
richard
