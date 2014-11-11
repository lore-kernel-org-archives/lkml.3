Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbaKKLU4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:20:56 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:50940 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbaKKLUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:20:54 -0500
Date: Tue, 11 Nov 2014 12:18:39 +0100
From: Beniamino Galvani <b.galvani@gmail.com>
To: Sean Young <sean@mess.org>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Carlo Caione <carlo@caione.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Subject: Re: [PATCH v2 2/3] media: rc: add driver for Amlogic Meson IR remote
 receiver
Message-ID: <20141111111839.GA17620@gmail.com>
References: <1415521928-25251-1-git-send-email-b.galvani@gmail.com>
 <1415521928-25251-3-git-send-email-b.galvani@gmail.com>
 <20141109203608.GA837@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141109203608.GA837@gofer.mess.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 09, 2014 at 08:36:09PM +0000, Sean Young wrote:
> > [...]
> > +	dev_info(dev, "receiver initialized\n");
> > +
> > +	return 0;
> > +out_unreg:
> > +	rc_unregister_device(ir->rc);
> 
> rc_unregister_device() already calls rc_free_device().

Right, I will fix this.

Thanks,
Beniamino
