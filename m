Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbbAMBC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 20:02:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37812 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbbAMBC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 20:02:27 -0500
Date: Mon, 12 Jan 2015 17:02:23 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "balbi@ti.com" <balbi@ti.com>, John Youn <John.Youn@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>,
        "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>,
        Yunzhi Li <lyz@rock-chips.com>, Kever Yang <kever.yang@rock-chips.com>,
        Nick Hudson <skrll@netbsd.org>
Subject: Re: New maintainer for dwc2
Message-ID: <20150113010223.GA25043@kroah.com>
References: <A2CA0424C0A6F04399FB9E1CD98E030484506EFD@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030484506EFD@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 11:14:54PM +0000, Paul Zimmerman wrote:
> Hi everyone,
> 
> I will be leaving Synopsys on Friday, Jan 16th, so the dwc2 driver
> will need a new maintainer.
> 
> I am recommending John Youn <johnyoun@synopsys.com> as the new
> maintainer.
> 
> On the plus side, John has quite a bit of experience with the dwc2
> controller, and has previous experience submitting kernel patches (for
> the xhci and dwc3 drivers). And being a Synopsys employee, he will have
> access to internal resources for support.
> 
> On the minus side, John has not worked directly with the in-kernel dwc2
> driver until very recently, and has not done maintainer work before.
> 
> If no one has any objections, I will submit a patch to MAINTAINERS in a
> couple of days making John the new dwc2 maintainer.

I don't have any objections.  John will still be sending patches to
Felipe through email, and not directly to me, right?

thanks,

greg k-h
