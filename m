Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515AbaBZTsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:48:41 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:54652 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaBZTsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:48:37 -0500
MIME-Version: 1.0
In-Reply-To: <201402241200.21944.arnd@arndb.de>
References: <201402241200.21944.arnd@arndb.de>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 26 Feb 2014 12:48:17 -0700
Message-ID: <CAErSpo5RV=w+DkgHSZZPOFGiEBBxMSraLV3TepYUZwDJuV+Jzg@mail.gmail.com>
Subject: Re: DMABOUNCE in pci-rcar
To: Arnd Bergmann <arnd@arndb.de>
Cc: Magnus Damm <damm@opensource.se>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Simon Horman <horms+renesas@verge.net.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        linux-sh@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 24, 2014 at 4:00 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> Hi Magnus,
>
> I noticed during randconfig testing that you enabled DMABOUNCE for the
> pci-rcar-gen2 driver as posted in this patch https://lkml.org/lkml/2014/2/5/30
>
> I didn't see the original post unfortunately, but I fear we have to
> revert it and come up with a better solution, ...

Sounds like I should drop the following patches from my pci/host-rcar
branch for now?

  PCI: rcar: Add DMABOUNCE support
  PCI: rcar: Enable BOUNCE in case of HIGHMEM
  PCI: rcar: Make the Kconfig dependencies more generic

Bjorn
