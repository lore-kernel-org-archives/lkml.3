Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab3BML0P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 06:26:15 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:60742 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933765Ab3BML0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 06:26:14 -0500
Date: Wed, 13 Feb 2013 12:26:23 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Rob Herring <robherring2@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: dma.c: fix memory leakage
Message-ID: <20130213112623.GA23860@gmail.com>
References: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
 <50FC6EB1.4050704@gmail.com>
 <20130122101053.GA2427@gmail.com>
 <20130212174025.GB17659@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212174025.GB17659@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 09:40:25AM -0800, Vinod Koul wrote:
> On Tue, Jan 22, 2013 at 10:10:53AM +0000, Cong Ding wrote:
> > On Sun, Jan 20, 2013 at 04:24:49PM -0600, Rob Herring wrote:
> > > On 01/19/2013 07:06 AM, Cong Ding wrote:
> > > > The memory allocated to ofdma might be a leakage when error occurs.
> > > > 
> > > > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> > > 
> > > You need to send this to whomever is working on DMA bindings.
> > Thank you bob, I added Vinod the the receiver list.
> I have moved the of/dma.c to dma/of-dma.c, can you regenerate this patch and
> resend to me
Sorry Vinod, I didn't manage to get this commit from either linux-next tree or
slave-dma tree, and the last commit by you for of/dma.c file is on Jan 7. Did
you have any hints for me to get the latest version dma/of-dma.c?
 - cong

