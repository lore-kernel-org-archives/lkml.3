Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaGFPYH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:24:07 -0400
Received: from mail-ve0-f173.google.com ([209.85.128.173]:36093 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaGFPYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:24:05 -0400
MIME-Version: 1.0
In-Reply-To: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
References: <1404240214-9804-1-git-send-email-Liviu.Dudau@arm.com>
From: Rob Herring <robherring2@gmail.com>
Date: Sun, 6 Jul 2014 10:23:43 -0500
Message-ID: <CAL_JsqK_CfagmiFOpOXVYGry22nGnCZL0ZXeJhYxb9zp=P2fsQ@mail.gmail.com>
Subject: Re: [PATCH v8 0/9] Support for creating generic PCI host bridges from DT
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: linux-pci <linux-pci@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Device Tree ML <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 1, 2014 at 1:43 PM, Liviu Dudau <Liviu.Dudau@arm.com> wrote:
> This is my resurected attempt at adding support for generic PCI host
> bridge controllers that make use of device tree information to
> configure themselves. I've tagged it as v8 although the patches
> have now been reshuffled in order to ease adoption so referring to
> the older versions might be a bit of a hoop jumping exercise.
>
> Changes from v7:
>   - Reordered the patches so that fixes and non-controversial patches
>     from v7 can be accepted more easily. If agreed I can split the
>     series again into patches that can be upstreamed easily and ones
>     that still need discussion.
>   - Moved the of_create_host_bridge() function to drivers/of/of_pci.c
>     to better reflect its target use.
>   - Added the function to remap the bus I/O resources that used to be
>     provided in my arm64 patch series and (re)named it pci_remap_iospace()
>   - Removed error code checking from parsing and mapping of IRQ from DT
>     in recognition that some PCI devices will not have legacy IRQ mappings.
>
> v7 thread here with all the historic information: https://lkml.org/lkml/2014/3/14/279

Can you publish a branch for this series please.

Rob
