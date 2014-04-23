Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757385AbaDWINM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 04:13:12 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55057 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753426AbaDWINJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 04:13:09 -0400
Date: Wed, 23 Apr 2014 10:13:05 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: sebastian.hesselbarth@gmail.com, tj@kernel.org,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ata: ahci: add AHCI support for Berlin SoCs
Message-ID: <20140423081305.GA24355@kwain>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
 <1398181105-19714-2-git-send-email-antoine.tenart@free-electrons.com>
 <4239617.ieu9uluV2B@amdc1032>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4239617.ieu9uluV2B@amdc1032>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 22, 2014 at 06:54:27PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Tuesday, April 22, 2014 05:38:20 PM Antoine Ténart wrote:

[…]

> > +static struct platform_driver ahci_berlin_driver = {
> > +	.probe	= ahci_berlin_probe,
> > +	.remove	= ata_platform_remove_one,
> > +	.driver	= {
> > +		.name		= "ahci-berlin",
> > +		.owner		= THIS_MODULE,
> > +		.of_match_table = ahci_berlin_of_match,
> 
> Please add a comment explaining lack of power management support
> (i.e. that your platform doesn't have PM support implemented yet).

I can add the power management support in the v2.

Thanks!

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
