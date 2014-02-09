Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBINZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:25:47 -0500
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:65517 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbaBINZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:25:46 -0500
Message-ID: <1391952344.25424.4.camel@x220>
Subject: Re: [Intel-gfx] agp/intel: can't ioremap flush page - no chipset
 flushing
From: Paul Bolle <pebolle@tiscali.nl>
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Date: Sun, 09 Feb 2014 14:25:44 +0100
In-Reply-To: <1391951759.6036.7.camel@artifact>
References: <1391886379.2669.11.camel@x41>
	 <CAKMK7uE6Gaq-ghgWJ+6Qyn7hrGzAMOHyGT9KQQJ+ij7omPV2Ew@mail.gmail.com>
	 <1391890927.1882.5.camel@x41>
	 <CAKMK7uFx2kksGgnuy9e0xiQRKpt=_+44O1V4wbX5yNBocvjBkg@mail.gmail.com>
	 <1391951759.6036.7.camel@artifact>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 13:25:45.0197 (UTC) FILETIME=[700AA1D0:01CF259A]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 13:15 +0000, Steven Newbury wrote:
> PCI resource allocation is undergoing some changes at the moment, it's
> definitely a bug if the Flush Page isn't getting allocated.  I'm looking
> forward to hopefully getting pci_bus_alloc_resource_fit() behaviour in
> mainline, it will provide much better resource allocation in the 32 bit
> PCI address space, and prevent problems like this from cropping up.
> 
> See Yinghai Lu's for-pci-res-alloc branch.
> 
> I've been carrying the changes in my local tree, but right now the
> upstream PCI changes are quite extensive.  He's planning on rebasing the
> branch soon.

Does this mean I might be better of not bisecting this just yet? Or are
these changes targeted at v3.15 (or later)?


Paul Bolle

