Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbaF3KZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 06:25:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53067 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755127AbaF3KZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:25:26 -0400
Date: Mon, 30 Jun 2014 12:20:14 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, tj@kernel.org,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v6 1/7] phy: add a driver for the Berlin SATA PHY
Message-ID: <20140630102014.GA5155@kwain>
References: <1402914392-6028-1-git-send-email-antoine.tenart@free-electrons.com>
 <1402914392-6028-2-git-send-email-antoine.tenart@free-electrons.com>
 <53A9685E.9090501@ti.com>
 <53A96A1C.5030800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53A96A1C.5030800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jun 24, 2014 at 05:37:56PM +0530, Varka Bhadram wrote:
> On 06/24/2014 05:30 PM, Kishon Vijay Abraham I wrote:
> >On Monday 16 June 2014 03:56 PM, Antoine Ténart wrote:
> >>+
> >>+static struct phy *phy_berlin_sata_phy_xlate(struct device *dev,
> >>+					     struct of_phandle_args *args)
> 
> Indent the function properly like this:
> static struct phy *phy_berlin_sata_phy_xlate(struct device *dev,
> 					     struct of_phandle_args *args)
> 
> check with checkpatch.pl script

Already fixed in v7.


Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
