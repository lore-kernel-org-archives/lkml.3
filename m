Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538Ab3BGX04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 18:26:56 -0500
Received: from meriadoc.sigma-star.at ([178.63.61.2]:58085 "EHLO
	meriadoc.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759428Ab3BGX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 18:26:53 -0500
Date: Fri, 8 Feb 2013 00:26:44 +0100
From: Richard Weinberger <richard@sigma-star.at>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Gstir <david@sigma-star.at>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: DMAR faults from unrelated device when vfio is used
Message-ID: <20130208002644.1ce3d958@spider.haslach.nod.at>
In-Reply-To: <1360277398.8412.16.camel@ul30vt.home>
References: <1359972630.2498.21.camel@riven-lux.site>
	<1359992968.11144.414.camel@bling.home>
	<1360071110.6200.19.camel@riven-lux.site>
	<1360078648.11144.558.camel@bling.home>
	<1360096613.11144.612.camel@bling.home>
	<20130206190908.79073124@spider.haslach.nod.at>
	<1360176440.11144.676.camel@bling.home>
	<20130206212553.667e6d8b@spider.haslach.nod.at>
	<1360190737.11144.731.camel@bling.home>
	<20130207232311.27a5600a@spider.haslach.nod.at>
	<1360277398.8412.16.camel@ul30vt.home>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 07 Feb 2013 15:49:58 -0700
schrieb Alex Williamson <alex.williamson@redhat.com>:
> > If I whitelist pcieport USB3 works within the guests. :-)
> > Binding 1c.0 and 1c.6 is no longer needed.
> > Next week I'll run some more tests with USB3 devices.
> 
> Great!  Thanks for the test.  I assume you didn't need to do anything
> with unbinding pciehp?

Yeah, unbinding from pciehp was not needed.
Next week I'll have physical access to that box and be able run more
tests.
So far everything looks fine.

Thanks,
//richard
