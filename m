Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbaA2C07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 21:26:59 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:17732 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbaA2C05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 21:26:57 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 28 Jan 2014 18:25:37 -0800
Subject: Re: [PATCH v3 3/6] misc: fuse: Add efuse driver for Tegra
From: Jim Lin <jilin@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Landley <rob@landley.net>, Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Danny Huang <dahuang@nvidia.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
In-Reply-To: <1390952176-30402-4-git-send-email-pdeschrijver@nvidia.com>
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com>
	 <1390952176-30402-4-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Jan 2014 10:26:18 +0800
Message-ID: <1390962378.2398.11.camel@jilin-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 07:36 +0800, Peter De Schrijver wrote:
> Implement fuse driver for Tegra20, Tegra30, Tegra114 and Tegra124.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>  Documentation/ABI/testing/sysfs-driver-tegra-fuse |    8 +
>  drivers/misc/fuse/Makefile                        |    1 +
>  drivers/misc/fuse/tegra/Makefile                  |    7 +
>  drivers/misc/fuse/tegra/fuse-tegra.c              |  228 ++++++++++++++++
>  drivers/misc/fuse/tegra/fuse-tegra20.c            |  136 ++++++++++
>  drivers/misc/fuse/tegra/fuse-tegra30.c            |  178 +++++++++++++
>  drivers/misc/fuse/tegra/fuse.h                    |   82 ++++++
Could we move this fuse.h to other folder under /include/linux
(like /include/linux/platform_data)
for other driver to include?
So other driver can invoke function to read fuse data if needed.

--nvpublic

