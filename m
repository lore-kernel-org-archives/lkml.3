Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3AaE3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 23:29:55 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37546 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3AaE3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 23:29:54 -0500
MIME-Version: 1.0
In-Reply-To: <20130126005533.25808.23022.stgit@amt.stowe>
References: <20130126005533.25808.23022.stgit@amt.stowe>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 30 Jan 2013 21:29:33 -0700
Message-ID: <CAErSpo55CUnYxE7JF_Mcee4aXU6vcW=O7N_LbAAAjZxZ5puNcg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Extend interfaces to access PCIe capabilities registers
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, jiang.liu@huawei.com, mcgrof@qca.qualcomm.com,
        mcgrof@do-not-panic.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 5:55 PM, Myron Stowe <myron.stowe@redhat.com> wrote:
> This series is a minor extension to Jiang Liu's recent efforts - [PATCH v3
> 00/32] provide interfaces to access PCIe capabilities registers - which
> adds an additional PCI Express accessor for obtaining a device's
> Capabilities Register.
>
> Reference: https://lkml.org/lkml/2012/8/1/253
> ---
>
> Myron Stowe (2):
>       PCI: Use PCI Express Capability accessors
>       PCI: introduce accessor to retrieve PCIe Capabilities Register
>
>
>  drivers/pci/access.c            |    4 ++--
>  drivers/pci/pcie/portdrv_core.c |    2 +-
>  include/linux/pci.h             |   11 ++++++++++-
>  3 files changed, 13 insertions(+), 4 deletions(-)

I applied these to pci/misc for v3.9.  Thanks!
