Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab3CBWw0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 17:52:26 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:47582 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab3CBWwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 17:52:24 -0500
Date: Sat, 2 Mar 2013 14:48:33 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC v2 2/3] power: power_supply: Add core support for
 supplied_nodes
Message-ID: <20130302224832.GA16720@lizard.sbx05280.losalca.wayport.net>
References: <1361488272-21010-1-git-send-email-rklein@nvidia.com>
 <1361488272-21010-3-git-send-email-rklein@nvidia.com>
 <5127D083.6020308@wwwdotorg.org>
 <5127EA13.9010403@nvidia.com>
 <512FB473.8060309@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <512FB473.8060309@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 02:48:03PM -0500, Rhyland Klein wrote:
[...]
> Anton, David, would you be adverse to the changing of supplied_to
> from being a
> list of batteries stored in a charger to being a list of chargers
> stored in batteries?

I wonder if we can support both ways?..

Thanks,
Anton
