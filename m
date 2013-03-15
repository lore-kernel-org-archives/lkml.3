Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3COG4L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 02:56:11 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:14102 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3COG4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 02:56:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 14 Mar 2013 23:49:22 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Fri, 15 Mar 2013 07:56:00 +0100
Subject: Re: [PATCH 1/1] amba: tegra-ahb: Fix build error w/ PM_SLEEP w/o
 PM_RUNTIME
Thread-Topic: [PATCH 1/1] amba: tegra-ahb: Fix build error w/ PM_SLEEP w/o
 PM_RUNTIME
Thread-Index: Ac4hSio/3dbc4NuCSfiHBRuEtYIWZw==
Message-ID: <20130315.085600.1539318572744189496.hdoyu@nvidia.com>
References: <1363252089-4120-1-git-send-email-hdoyu@nvidia.com><5142B05A.2070408@wwwdotorg.org>
In-Reply-To: <5142B05A.2070408@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Fri, 15 Mar 2013 06:23:38 +0100:

> On 03/14/2013 03:08 AM, Hiroshi Doyu wrote:
> > Make this depend on CONFIG_PM. This protection is necessary to not
> > cause any build errors with any combination of PM features especially
> > when supporting a new SoC where each PM features are being enabled
> > one-by-one during its depelopment.
> 
> Looks fine to me.
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> I assume Russell will want this to go through his patch tracker.

FYI: Patch has been accepted as patch 7675/1
