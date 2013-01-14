Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305Ab3ANQOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 11:14:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:39352 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756460Ab3ANQOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 11:14:15 -0500
Date: Mon, 14 Jan 2013 08:14:12 -0800
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>
Subject: Re: [PATCH] mfd, TWL4030: TWL4030 need select REGMAP_I2C
Message-ID: <20130114161412.GB14721@kroah.com>
References: <1356358796.1688.3.camel@cliu38-desktop-build>
 <50E162F8.8030403@ti.com>
 <27240C0AC20F114CBF8149A2696CBE4A203154@SHSMSX101.ccr.corp.intel.com>
 <50F3CF9B.8010608@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F3CF9B.8010608@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 10:27:55AM +0100, Peter Ujfalusi wrote:
> Hi Liu,
> 
> On 01/14/2013 03:18 AM, Liu, Chuansheng wrote:
> > Hi maintainers,
> > 
> > Could you help to push this patch?
> > Every time syncing the latest code, always meet this build error.
> > Sorry to disturb.
> 
> First of all I'm sorry for this, since this is my mistake to not update the
> Kconfig file at the same time.
> AFAIK Samuel is really busy with Intel stuff (might be worth pinging him
> within Intel), but I'm sure he is going to do everything he can to resolve this.
> We can ask Greg to take this further as well. Whichever is going to be the faster.

Hm, I'm not taking mfd patches lately, but if needed, I can, just let me
know.

thanks,

greg k-h
