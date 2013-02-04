Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785Ab3BDURB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:17:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39244 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754494Ab3BDUQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:16:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: e1000-devel@lists.sourceforge.net, linux-pci@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] pci/e1000e: return runtime-pm back to work
Date: Mon, 04 Feb 2013 21:23:17 +0100
Message-ID: <2306912.u6v1yvkaml@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130204115246.5569.85829.stgit@zurg>
References: <20130204115246.5569.85829.stgit@zurg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 04, 2013 03:55:47 PM Konstantin Khlebnikov wrote:
> This patchset contains some fixes for e1000e diver (broken since v2.6.35)
> and some related fixes and useful debug for PCI code.
> 
> All together this fixes my regression report for v3.8-rc1:
> https://lkml.org/lkml/2013/1/1/25
> 
> patchset was seriously reworked since v1:
> http://lkml.org/lkml/2013/1/18/147
> 
> ---
> 
> Konstantin Khlebnikov (6):
>       e1000e: fix pci-device enable-counter balance
>       PCI: don't touch enable_cnt in pci_device_shutdown()
>       PCI: catch enable-counter underflows
>       e1000e: fix runtime power management transitions
>       PCI/PM: warn about incomplete actions in ->runtime_suspend() callback
>       e1000e: fix accessing to suspended device
> 
> Rafael J. Wysocki (1):
>       PCI/PM: clear state_saved during suspend
> 
> 
>  drivers/net/ethernet/intel/e1000e/ethtool.c |   13 ++++
>  drivers/net/ethernet/intel/e1000e/netdev.c  |   82 +++++++--------------------
>  drivers/pci/pci-driver.c                    |   21 +++++--
>  drivers/pci/pci.c                           |    3 +
>  4 files changed, 53 insertions(+), 66 deletions(-)

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

for all patches except for [6/7].

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
