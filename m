Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098AbaKRVnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 16:43:40 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2253 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbaKRVni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 16:43:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 18 Nov 2014 13:41:59 -0800
From: Thierry Reding <treding@nvidia.com>
To: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>, <swarren@nvidia.com>,
        <pdeschrijver@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Date: Tue, 18 Nov 2014 22:43:31 +0100
Message-ID: <149c4dc1108.2771.03bddb20d4030f1f862c9d4a07956621@nvidia.com>
In-Reply-To: <546B6D14.3090807@vanguardiasur.com.ar>
References: <1414516354-29932-1-git-send-email-ezequiel@vanguardiasur.com.ar>
 <546B6D14.3090807@vanguardiasur.com.ar>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0 AquaMail/1.5.0.19 (build: 2100846)
Subject: Re: [PATCH] misc: Remove unused fuse/Makefile
MIME-Version: 1.0
X-Originating-IP: [10.21.180.231]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On November 18, 2014 5:02:14 PM Ezequiel Garcia 
<ezequiel@vanguardiasur.com.ar> wrote:
> (increasing CC list)
>
> On 10/28/2014 02:12 PM, Ezequiel Garcia wrote:
> > This commit:
> >
> > commit 783c8f4c84451bc444e314a71b447239c6ef6fd9
> > Author: Peter De Schrijver <pdeschrijver@nvidia.com>
> > Date:   Thu Jun 12 18:36:37 2014 +0300
> >
> >     soc/tegra: Add efuse driver for Tegra
> >
> > introduced a fuse driver in drivers/soc. While at it, an unused file
> > drivers/misc/fuse/Makefile sneaked in, apparently as a left over from
> > a previous series. Remove it.
> >
> > Signed-off-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
> > ---
> >  drivers/misc/fuse/Makefile | 1 -
> >  1 file changed, 1 deletion(-)
> >  delete mode 100644 drivers/misc/fuse/Makefile
> >
> > diff --git a/drivers/misc/fuse/Makefile b/drivers/misc/fuse/Makefile
> > deleted file mode 100644
> > index 0679c4f..0000000
> > --- a/drivers/misc/fuse/Makefile
> > +++ /dev/null
> > @@ -1 +0,0 @@
> > -obj-$(CONFIG_ARCH_TEGRA)	+= tegra/
> >

I sent the same patch a couple of days ago, so:

Acked-by: Thierry Reding <treding@nvidia.com>

--
nvpublic


