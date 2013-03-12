Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab3CLSkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:40:21 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:47958 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3CLSkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:40:16 -0400
Date: Tue, 12 Mar 2013 11:40:10 -0700
From: Tejun Heo <tj@kernel.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, axboe@kernel.dk,
        jmoyer@redhat.com, zab@redhat.com
Subject: Re: [PATCH 30/31] driver/base: implement subsys_virtual_register()
Message-ID: <20130312184010.GH25266@htj.dyndns.org>
References: <CAPXgP11Zuz166v_M2EhGDY1U5vKtUwE+fTPAWYEu7UxXsr=g=A@mail.gmail.com>
 <20130305204327.GK12795@htj.dyndns.org>
 <20130307233116.GF10304@kroah.com>
 <CAPXgP10CEMgdOW23txWwwh0xSVd97fKH31xdKjE8Wy51kO6XdQ@mail.gmail.com>
 <20130310115702.GB24522@htj.dyndns.org>
 <20130310164530.GA4523@kroah.com>
 <CAPXgP136685qRguL6C91C+NE7GbgrU7CdpQJW89Fi-_Vw6EukA@mail.gmail.com>
 <20130310172430.GA4723@kroah.com>
 <CAPXgP13Vjp_H-_Xvm0O4D0=k02H7bb=dEmx43w8N+EZisxeZ8g@mail.gmail.com>
 <20130310183400.GH24522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130310183400.GH24522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 10, 2013 at 11:34:00AM -0700, Tejun Heo wrote:
> On Sun, Mar 10, 2013 at 06:50:34PM +0100, Kay Sievers wrote:
> > > Yes, but I can keep Tejun's patch in my local queue for now, dbus is
> > > going to not make 3.10, right?
> > 
> > No, sure not. It's just something we will need there too, but there is
> > no hurry, it's only a cosmetic issue anyway and nothing that matters
> > functionality-wise.
> 
> In that case, I'll just route it together with the rest of workqueue
> changes with Greg's ack added.

The patch is applied to wq/for-3.10-subsys_virtual_register which
contains only this patch on top of v3.9-rc1.  If somebody ever needs
it in this cycle, please feel free to pull the following branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.10-subsys_virtual_register

Thanks.

-- 
tejun
