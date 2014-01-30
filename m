Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaA3JqM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:46:12 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:7472 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaA3JqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:46:08 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 30 Jan 2014 01:44:41 -0800
Date: Thu, 30 Jan 2014 11:45:49 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/6] efuse driver for Tegra
Message-ID: <20140130094549.GD26588@tbergstrom-lnx.Nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
 <CAP=VYLpJT1T2RGuK73TXhSYn-K+ZrLx9FuhQe+hVXYGnfoOBcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAP=VYLpJT1T2RGuK73TXhSYn-K+ZrLx9FuhQe+hVXYGnfoOBcQ@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 29, 2014 at 04:00:27PM +0100, Paul Gortmaker wrote:
> On Tue, Jan 28, 2014 at 6:36 PM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> > This driver allows userspace to read the raw efuse data. Its userspace
> > interface is modelled after the sunxi_sid driver which provides similar
> > functionality for some Allwinner SoCs. It has been tested on
> > Tegra20 (ventana), Tegra30 (beaverboard) and Tegra114 (dalmore).
> >
> > Changes since v1:
> >
> > * Add documentation for sysfs interface
> > * Cleanup messages
> >
> > Changes since v2:
> >
> > * Incorporate early fuse code
> > * Remove module support
> > * Make driver always build when Tegra platform is selected
> 
> Given the above, you should be able to remove #include <linux/module.h>
> and MODULE_DEVICE_TABLE, etc.

Indeed. Thanks for noticing!

Cheers,

Peter.
