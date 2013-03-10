Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab3CJSeH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 14:34:07 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:48986 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab3CJSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 14:34:05 -0400
Date: Sun, 10 Mar 2013 11:34:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com
Subject: Re: [PATCH 30/31] driver/base: implement subsys_virtual_register()
Message-ID: <20130310183400.GH24522@htj.dyndns.org>
References: <20130302181727.GB2051@kroah.com>
 <CAPXgP11Zuz166v_M2EhGDY1U5vKtUwE+fTPAWYEu7UxXsr=g=A@mail.gmail.com>
 <20130305204327.GK12795@htj.dyndns.org>
 <20130307233116.GF10304@kroah.com>
 <CAPXgP10CEMgdOW23txWwwh0xSVd97fKH31xdKjE8Wy51kO6XdQ@mail.gmail.com>
 <20130310115702.GB24522@htj.dyndns.org>
 <20130310164530.GA4523@kroah.com>
 <CAPXgP136685qRguL6C91C+NE7GbgrU7CdpQJW89Fi-_Vw6EukA@mail.gmail.com>
 <20130310172430.GA4723@kroah.com>
 <CAPXgP13Vjp_H-_Xvm0O4D0=k02H7bb=dEmx43w8N+EZisxeZ8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP13Vjp_H-_Xvm0O4D0=k02H7bb=dEmx43w8N+EZisxeZ8g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 06:50:34PM +0100, Kay Sievers wrote:
> > Yes, but I can keep Tejun's patch in my local queue for now, dbus is
> > going to not make 3.10, right?
> 
> No, sure not. It's just something we will need there too, but there is
> no hurry, it's only a cosmetic issue anyway and nothing that matters
> functionality-wise.

In that case, I'll just route it together with the rest of workqueue
changes with Greg's ack added.

Thanks!

-- 
tejun
