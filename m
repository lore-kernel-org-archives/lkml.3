Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbaBMMe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 07:34:57 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:44820 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaBMMey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 07:34:54 -0500
Message-ID: <52FCBBEA.70300@codethink.co.uk>
Date: Thu, 13 Feb 2014 12:34:50 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-pci@vger.kernel.org, horms@verge.net.au, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, valentine.barshak@cogentembedded.com,
        geert@linux-m68k.org, bhelgaas@google.com
Subject: Re: [PATCH 00/08] PCI: rcar: Recent driver patches from Ben Dooks
 and me
References: <20140213030302.10398.37322.sendpatchset@w520>
In-Reply-To: <20140213030302.10398.37322.sendpatchset@w520>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/02/14 03:03, Magnus Damm wrote:
> PCI: rcar: Recent driver patches from Ben Dooks and me
>
> [PATCH 01/08] PCI: rcar: check platform_get_irq() return code
> [PATCH v2 02/08] PCI: rcar: add error interrupt handling
> [PATCH 03/08] PCI: rcar: fix bridge logic configuration accesses
> [PATCH v2 04/08] PCI: rcar: Register each instance independently
> [PATCH v2 05/08] PCI: rcar: Break out window size handling
> [PATCH v2 06/08] PCI: rcar: Add DMABOUNCE support
> [PATCH 07/08] PCI: rcar: Enable BOUNCE in case of HIGHMEM
> [PATCH 08/08] PCI: rcar: Make the Kconfig dependencies more generic
>
> These patches update the pci-rcar-gen2.c driver with patches from
> Ben Dooks and me. The first 3 are written by Ben (thanks!) and are
> included here to show what I would like to have merged and what I
> rebased my patches on. The following 4 are updated versions of
>
> [PATCH 00/04] PCI: rcar: Driver model and physical address space update
>
> The final patch is a new one that fixes up the Kconfig dependencies.

Thanks. Is there any chance of getting this driver device-tree
enabled too?

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
