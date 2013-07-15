Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246Ab3GOPtu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:49:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932679Ab3GOPtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:49:49 -0400
Date: Mon, 15 Jul 2013 07:54:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Srikanth Thokala <srikanth.thokala@xilinx.com>
Cc: arnd@arndb.de, rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@linaro.org,
        Michal Simek <michal.simek@xilinx.com>,
        Srikanth Thokala <sthokal@xilinx.com>
Subject: Re: [PATCH RFC] trafgen: xilinx: add axi traffic generator driver
Message-ID: <20130715145412.GA32349@kroah.com>
References: <1373888388-23297-1-git-send-email-sthokal@xilinx.com>
 <c7f93809-56dd-4780-8e1e-962b8ebc7f9f@CO9EHSMHS001.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7f93809-56dd-4780-8e1e-962b8ebc7f9f@CO9EHSMHS001.ehs.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 05:09:48PM +0530, Srikanth Thokala wrote:
> This is the driver for AXI Traffic Generator IP. The AXI
> Traffic Generator IP is a core that stresses the AXI4
> interconnect and other AXI4 peripherals in the system.
> It generates a wide variety of AXI4 transactions based on
> the core programming.
> 
> Architecture of the core is broadly separated into a master
> and slave block, each of which contains the write block and
> read block. Other support functions are provided by the
> control registers and three internal RAMs - Master RAM,
> Command RAM, Parameter RAM. The initialisation sequence
> includes programming Command RAM with commands, data into
> Master RAM (optional Parameter RAM programming) and then
> enable master logic using control register interface.
> This sequence generates traffic to cores connected in the
> h/w design.
> 
> The driver for this IP is designed to be a module with
> sysfs interface.  All the control registers and internal
> RAMs can be accessed through sysfs interface.
> 
> NOTE: All the sysfs functions need to be documented
> as per kernel-doc format.

Please do that so we can properly understand the api you are creating
here.

thanks,

greg k-h
