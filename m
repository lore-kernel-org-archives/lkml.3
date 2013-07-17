Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753700Ab3GQKoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 06:44:23 -0400
Received: from service87.mimecast.com ([91.220.42.44]:55661 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249Ab3GQKoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 06:44:22 -0400
Date: Wed, 17 Jul 2013 11:44:17 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Pawel Moll <Pawel.Moll@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Olof Johansson <olof@lixom.net>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>, Achin Gupta <Achin.Gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Subject: Re: [RFC PATCH v5 0/1] drivers: mfd: Versatile Express SPC support
Message-ID: <20130717104416.GA1896@e102568-lin.cambridge.arm.com>
References: <1373990743-23106-1-git-send-email-lorenzo.pieralisi@arm.com>
 <1374052705.3146.86.camel@hornet>
MIME-Version: 1.0
In-Reply-To: <1374052705.3146.86.camel@hornet>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 17 Jul 2013 10:44:20.0061 (UTC) FILETIME=[97BDE8D0:01CE82DA]
X-MC-Unique: 113071711442002401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 17, 2013 at 10:18:25AM +0100, Pawel Moll wrote:
> On Tue, 2013-07-16 at 17:05 +0100, Lorenzo Pieralisi wrote:
> > /drivers/mfd is probably not the right place for this code as it stands (but
> > probably will be when the entire driver, with DVFS and config interface, is
> > complete).
> 
> Not that it really matters now, but my vexpress-sysreg rework will -
> most likely - leave only skeleton in the MFD (registering mfd_cells) and
> other stuff is going to be spread all around. Then I'm planning to move
> the remaining of the vexpress-specific initialization to
> drivers/platform/arm/vexpress.c, so maybe sticking vexpress-spc.c to
> this (non-existing yet) directory would be the right thing to do?

Done. I do not think there is a point in splitting the patch to create
the dir and make infrastructure, so I squashed everything in the
original patch. I have not added any maintainer for that dir/file, I
guess it can wait till you finish the rework so that you can add
yourself there.

If that's all I need to change I do not even think that reposting is
necessary.

It does matter though, since it implies changes on who is in charge of
ack/nack'ing this code, if it is no more an mfd matter.

I will wait to check all interested/concerned parties opinions, that are
always welcome.

> Other than that:
> 
> Acked-by: Pawel Moll <pawel.moll@arm.com>

Thank you !!!
Lorenzo

