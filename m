Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756276Ab3G3OYC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:24:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40658 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3G3OX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:23:59 -0400
Date: Tue, 30 Jul 2013 07:25:17 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, tony@atomide.com,
        linux@arm.linux.org.uk, eballetbo@gmail.com, javier@dowhile0.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH 2/2] arm: omap: remove *.auto* from device names given in
 usb_bind_phy
Message-ID: <20130730142517.GA29015@kroah.com>
References: <51F74BC8.7020903@ti.com>
 <20130730060134.GD9155@radagast>
 <51F7590B.4020705@ti.com>
 <20130730061830.GE9155@radagast>
 <51F75C40.4060406@ti.com>
 <20130730062844.GH9155@radagast>
 <51F7613C.5070803@ti.com>
 <20130730071611.GD16441@radagast>
 <51F7752B.8050804@ti.com>
 <20130730081520.GH16441@radagast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730081520.GH16441@radagast>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 11:15:20AM +0300, Felipe Balbi wrote:
> > > look at Greg's and my reply to that email.
> > 
> > but finally Greg agreed to what Tomasz proposed no?
> 
> that's not what I see in the thread. I see Greg agreed to regulator's
> own IDs being sequentially created, but he mentions device names can
> change.

And that no one should _ever_ rely on them to be a specific "name", the
bus is responsible for creating the id, it could be "random" and
everything should work just fine.

thanks,

greg k-h
