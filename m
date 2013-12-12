Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820Ab3LLNsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:48:01 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:51139 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3LLNr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:47:58 -0500
Date: Thu, 12 Dec 2013 08:47:53 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        b.zolnierkie@samsung.com, m.szyprowski@samsung.com,
        andrzej.p@samsung.com, Kyungmin Park <kyungmin.park@samsung.com>,
        Matt Porter <matt.porter@linaro.org>
Subject: Re: [PATCH 1/2] USB: gadget: s3c-hsotg: fix maxpacket size in
 s3c_hsotg_irq_enumdone
Message-ID: <20131212134753.GC20773@beef>
References: <1386331425-16594-1-git-send-email-r.baldyga@samsung.com>
 <1386331425-16594-2-git-send-email-r.baldyga@samsung.com>
 <20131206203523.GK21086@saruman.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131206203523.GK21086@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 06, 2013 at 02:35:23PM -0600, Felipe Balbi wrote:
> Hi,
> 
> On Fri, Dec 06, 2013 at 01:03:44PM +0100, Robert Baldyga wrote:
> > This patch set maximum possible maxpacket value for each speed. Previous
> > values didn't allow to use maxpacket sizes greater than 64 in full speed
> > and 512 in high speed, although hardware is able to handle up to 1023 in fs
> > and 1024 in hs.
> > 
> > Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> > Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Matt, will this cause any problems for your efforts on Bcom ?

I tested this patch in both full and high speed mode on my Capri board
and it works fine for me in both cases.

Tested-by: Matt Porter <mporter@linaro.org>

Thanks,
Matt
