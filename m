Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3KLHFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:05:10 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35892 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262Ab3KLHEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:04:51 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: set dma_mask to point to coherent_dma_mask
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Rob Herring <robherring2@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <alpine.DEB.2.02.1311111658100.26077@kaball.uk.xensource.com>
References: <1383109522-6879-1-git-send-email-robherring2@gmail.com> <20131102180724.D8FC5C40F02@trevor.secretlab.ca> <alpine.DEB.2.02.1311061642270.26077@kaball.uk.xensource.com> <alpine.DEB.2.02.1311111658100.26077@kaball.uk.xensource.com>
Date: Tue, 12 Nov 2013 07:01:14 +0000
Message-Id: <20131112070114.73AE3C421A6@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Nov 2013 16:59:14 +0000, Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:
> On Wed, 6 Nov 2013, Stefano Stabellini wrote:
> > On Sat, 2 Nov 2013, Grant Likely wrote:
> > > On Wed, 30 Oct 2013 00:05:22 -0500, Rob Herring <robherring2@gmail.com> wrote:
> > > > From: Rob Herring <rob.herring@calxeda.com>
> > > > 
> > > > Platform devices created by DT code don't initialize dma_mask pointer to
> > > > anything. Set it to coherent_dma_mask by default if the architecture
> > > > code has not set it.
> > > > 
> > > > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > > 
> > > I believe this is okay. I haven't done any testing to back up that
> > > opinion though.
> > 
> > Tested-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> BTW I hope you are planning on sending this upstream soon, because
> without it I can very easily corrupt my root fs by simply booting the system.

Gah! That's pretty nasty. It is in Rob's for-next branch, but it hasn't
been marked for backporting to stable. Best thing to do here is for
either you or Rob to repost the patch to stable@vger.kernel.org and
include the commit id from Rob's tree. It's not upstream yet, but it
will be soon.

How far back in kernel releases do you want the patch backported to?

g.
