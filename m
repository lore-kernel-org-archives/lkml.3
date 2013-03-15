Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab3COFon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 01:44:43 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5000 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab3COFom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 01:44:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 14 Mar 2013 22:44:41 -0700
Message-ID: <1363326713.3311.50.camel@bilhuang-vm1>
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
From: Bill Huang <bilhuang@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 14 Mar 2013 22:51:53 -0700
In-Reply-To: <5142AF55.80708@nvidia.com>
References: <1363258680-12600-1-git-send-email-bilhuang@nvidia.com>
	 <5142AF55.80708@nvidia.com>
X-Mailer: Evolution 3.2.3-0ubuntu6 
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-9"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-15 at 13:19 +0800, Stephen Warren wrote:
> On 03/14/2013 04:58 AM, Bill Huang wrote:
> > Hook up "pm_power_off" to palmas power off routine if there is DT
> > property "ti,system-power-controller" defined, so platform which is
> > powered by this regulator can be powered off properly.
> 
> > diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> 
> > +	pdata->pm_off = of_property_read_bool(node,
> > +			"ti,system-power-controller");
> 
> You would need to add that property to the DT binding documentation for
> this device.
Does it work that some time later Laxmain helps to add it when he
submits his pmic bindings for Palmas?


