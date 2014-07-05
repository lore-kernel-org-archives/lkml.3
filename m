Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaGERcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 13:32:09 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:48208 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbaGERcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 13:32:05 -0400
Date: Sat, 5 Jul 2014 11:32:00 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, jg1.han@samsung.com, mohit.kumar@st.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        Pratyush Anand <pratyush.anand@gmail.com>
Subject: Re: [PATCH 0/3] dra7: Add PCIe support
Message-ID: <20140705173200.GA26618@google.com>
References: <1403719007-9352-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403719007-9352-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 11:26:44PM +0530, Kishon Vijay Abraham I wrote:
> [1] is split into separate series in order for individual subsystem
> Maintainers to pick up the patches. This series handles the PCIe
> support for DRA7.
> 
> Rebased to 3.16-rc2.
> 
> [1] -> https://lkml.org/lkml/2014/5/29/258
> 
> Kishon Vijay Abraham I (3):
>   PCI: designware: Configuration space should be specified in 'reg'
>   PCI: designware: use untranslated address while programming ATU
>   PCI: host: pcie-dra7xx: add support for pcie-dra7xx controller

Mohit, I see your ack for [1/3], but not for [2/3]; are you OK with that,
too?

Pratyush, you had some questions about [2/3]; are you happy with that one?

[3/3] adds the devicetree binding; I'd like somebody to check that out.

Also, there's no MAINTAINERS update for pci-dra7xx.c.  Kishon, can you
include an update for that?

Kishon, can you collect the acks and post a v2 series with those and the
MAINTAINERS update?

Bjorn

> 
>  .../devicetree/bindings/pci/designware-pcie.txt    |    4 +
>  Documentation/devicetree/bindings/pci/ti-pci.txt   |   59 +++
>  drivers/pci/host/Kconfig                           |   10 +
>  drivers/pci/host/Makefile                          |    1 +
>  drivers/pci/host/pci-dra7xx.c                      |  458 ++++++++++++++++++++
>  drivers/pci/host/pcie-designware.c                 |   66 ++-
>  drivers/pci/host/pcie-designware.h                 |    4 +
>  7 files changed, 589 insertions(+), 13 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
>  create mode 100644 drivers/pci/host/pci-dra7xx.c
> 
> -- 
> 1.7.9.5
> 
