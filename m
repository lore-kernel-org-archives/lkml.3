Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498AbaBDTXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:23:50 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62742 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755069AbaBDTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:23:46 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Subject: Re: [RFC PATCH V3 1/4] pci: APM X-Gene PCIe controller driver
Date: Tue, 4 Feb 2014 20:22:57 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Tanmay Inamdar <tinamdar@apm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches <patches@apm.com>,
        Jon Masters <jcm@redhat.com>, Liviu Dudau <Liviu.Dudau@arm.com>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com> <4985267.LnsktRmabM@wuerfel> <20140203221559.GG2519@obsidianresearch.com>
In-Reply-To: <20140203221559.GG2519@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201402042022.57267.arnd@arndb.de>
X-Provags-ID: V02:K0:InLZfh+jTH4zDRBfA6xmTy0PQcrHjWUtbNImKvILN3W
 5o1zCcUvWet1tz3EajZtEtOK1UOcAw1dsH/lms9kqbOudeBTCb
 hKuqQV5vPh6Rh0FYdSbwCq+4z/cMtfrsCadjuzHRD8gx77ajtq
 xGrmx9AyXBhbfGMQkI9xP6oo+2JgLwsrb9jP37XVz9F4W+BREF
 Ct5vWCjGJ6gzXbjY7wg/izUe7gJYqlzaUqLUIL74Vp2fNMiw29
 36eeT8HNY/LCCJlSs254c7PDyC1e8O4cLjw52dpNPLq7/GnCQM
 UKRAT4J4YfPlPjnIVznXQWMChiOpsDUSovKEUb/Yt+f2XGbCXo
 yzEoSseNZDDPVLJLfdsW1yAdkNgwUb7Vg6O6BY4u/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 February 2014, Jason Gunthorpe wrote:
> On Mon, Feb 03, 2014 at 09:12:32PM +0100, Arnd Bergmann wrote:
> 
> > Are you sure that is true for the root bridge as well? I don't
> > remember the details, but I though that for the host bridge,
> > we don't actually look at the BARs at all.
> 
> That is right, but this isn't a host bridge device, it is a PCI-PCI
> bridge with root complex registers. The root complex bridge is not the
> same as the host bridge.
> 
> Unfortunately the implementation is non-conforming. :(

Ok, I see. I was probably asking the wrong question then earlier
when I tried to find out what this is.

	Arnd
