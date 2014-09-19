Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938AbaISVBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:01:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54866 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757804AbaISVBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:01:51 -0400
Date: Fri, 19 Sep 2014 14:01:50 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Take dwc2 driver through Felipe's tree?
Message-ID: <20140919210150.GA25927@kroah.com>
References: <A2CA0424C0A6F04399FB9E1CD98E0304844D9D41@US01WEMBX2.internal.synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E0304844D9D41@US01WEMBX2.internal.synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 08:52:07PM +0000, Paul Zimmerman wrote:
> Hi Greg,
> 
> How would you feel about Felipe taking the dwc2 driver into his tree?
> There has been quite a bit of increased activity with dwc2 lately, and
> I know you already have more than enough stuff on your plate already.
> So this would mean one less thing for you to worry about. Plus it
> would mean an extra layer of review before getting to you.
> 
> I've already talked to Felipe about it, and he's fine with it. If
> you're OK with it, I think I just need to send a patch adding a T:
> line to the MAINTAINERS entry, showing Felipe's tree?
> 
> I guess we would want to do this just before you close your USB tree,
> and you could announce it then?

No objection from me.  I'm working in my patch backlog right now, should
get through them by the end of the day, so feel free to send me a
MAINTAINERS patch I can use.

thanks,

greg k-h
