Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab3J1SAP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 14:00:15 -0400
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:7717
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757242Ab3J1SAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 14:00:13 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zz98dI936eI1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1382983205.3410.6.camel@snotra.buserror.net>
Subject: Re: [PATCH 3/4] VFIO: pci: amend vfio-pci for explicit binding via
 sysfs only
From: Scott Wood <scottwood@freescale.com>
To: Alex Williamson <alex.williamson@redhat.com>
CC: Kim Phillips <kim.phillips@linaro.org>,
        Bhushan Bharat <R65777@freescale.com>,
        Wood Scott <B07421@freescale.com>, Yoder Stuart <B08248@freescale.com>,
        <christoffer.dall@linaro.org>, <linux-kernel@vger.kernel.org>,
        <a.motakis@virtualopensystems.com>, <agraf@suse.de>,
        Sethi Varun <B16395@freescale.com>, <peter.maydell@linaro.org>,
        <santosh.shukla@linaro.org>, <kvm@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Date: Mon, 28 Oct 2013 13:00:05 -0500
In-Reply-To: <1382982462.4097.38.camel@ul30vt.home>
References: <1381418830.7979.405.camel@snotra.buserror.net>
	 <1381472840-3470-1-git-send-email-kim.phillips@linaro.org>
	 <1381472840-3470-3-git-send-email-kim.phillips@linaro.org>
	 <1382982462.4097.38.camel@ul30vt.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 11:47 -0600, Alex Williamson wrote:
> On Fri, 2013-10-11 at 01:27 -0500, Kim Phillips wrote:
> > Force the vfio-pci driver to only be bound explicitly via sysfs to avoid
> > conflics with other drivers in the event of a hotplug.
> 
> We can't break userspace, so we can't disable the current method of
> binding devices to vfio-pci.  We can add a new method and perhaps
> deprecate the existing mechanism to be removed at some point in the
> future.  Thanks,

I thought the existing method involved using sysfs bind, and this was
just eliminating a race.  How does the bind get triggered currently?

-Scott



