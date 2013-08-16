Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab3HQAky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:40:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57814 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911Ab3HQAku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:40:50 -0400
Date: Fri, 16 Aug 2013 15:35:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 2/4] driver core: Allow early registration of devices
Message-ID: <20130816223523.GA31247@kroah.com>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
 <1376685563-1053-3-git-send-email-treding@nvidia.com>
 <20130816210637.GC2198@kroah.com>
 <20130816215530.GA14464@mithrandir>
 <CACxGe6uhiKY7a0+aViEamwKbE2tJicVc8CMZChBUaf+KYTs5rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6uhiKY7a0+aViEamwKbE2tJicVc8CMZChBUaf+KYTs5rw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:20:55PM +0100, Grant Likely wrote:
> Also, for the devices that are created early, is it really appropriate
> to use APIs that require a struct device? I could easily argue that
> anything done at early boot should only be the bare minimum to allow
> the kernel to get to initcalls, and so mucking about with devices is
> inappropriate because it really messes with the assumptions made in
> the design of the driver model.

I agree, this could get really messy, really fast, and be a place that
people abuse quite easily.

greg k-h
