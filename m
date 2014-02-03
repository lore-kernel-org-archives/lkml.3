Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879AbaBCWQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 17:16:13 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:52642 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751114AbaBCWQK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 17:16:10 -0500
Date: Mon, 3 Feb 2014 15:15:59 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Subject: Re: [RFC PATCH V3 1/4] pci: APM X-Gene PCIe controller driver
Message-ID: <20140203221559.GG2519@obsidianresearch.com>
References: <1390599168-13150-1-git-send-email-tinamdar@apm.com>
 <201401301516.27091.arnd@arndb.de>
 <CACoXjcnXoysMeBsGuOb3t5b10zdeJ8pOnuOOzR8AaZhsOOYVEw@mail.gmail.com>
 <4985267.LnsktRmabM@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4985267.LnsktRmabM@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 09:12:32PM +0100, Arnd Bergmann wrote:

> Are you sure that is true for the root bridge as well? I don't
> remember the details, but I though that for the host bridge,
> we don't actually look at the BARs at all.

That is right, but this isn't a host bridge device, it is a PCI-PCI
bridge with root complex registers. The root complex bridge is not the
same as the host bridge.

Unfortunately the implementation is non-conforming. :(

Jason
