Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754685Ab3I1Age (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 20:36:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab3I1Agc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 20:36:32 -0400
Date: Fri, 27 Sep 2013 17:37:42 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: swarren@wwwdotorg.org, bcousson@baylibre.com, tony@atomide.com,
        balbi@ti.com, s.nawrocki@samsung.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, linux@arm.linux.org.uk,
        jkosina@suse.cz, m.chehab@samsung.com, cesarb@cesarb.net,
        joe@perches.com, davem@davemloft.net, davidb@codeaurora.org,
        sameo@linux.intel.com, peter.ujfalusi@ti.com, t-kristo@ti.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        akpm@linux-foundation.org, balajitk@ti.com, george.cherian@ti.com,
        nsekhar@ti.com, rogerq@ti.com
Subject: Re: [PATCH v12 0/7] PHY framework
Message-ID: <20130928003742.GA3659@kroah.com>
References: <1380263012-9687-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380263012-9687-1-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 11:53:24AM +0530, Kishon Vijay Abraham I wrote:
> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> the PHY with or without using phandle.
> 
> This framework will be of use only to devices that uses external PHY (PHY
> functionality is not embedded within the controller).
> 
> The intention of creating this framework is to bring the phy drivers spread
> all over the Linux kernel to drivers/phy to increase code re-use and to
> increase code maintainability.
> 
> Comments to make PHY as bus wasn't done because PHY devices can be part of
> other bus and making a same device attached to multiple bus leads to bad
> design.
> 
> If the PHY driver has to send notification on connect/disconnect, the PHY
> driver should make use of the extcon framework. Using this susbsystem
> to use extcon framwork will have to be analysed.
> 
> You can find this patch series @
> git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git testing
> 
> I'll create a new branch *next* once this patch series is finalized. All the
> PHY driver development that depends on PHY framework can be based on this
> branch.
> 
> Did USB enumeration testing in panda and beagle after applying [1] (needed for
> non-dt)

All now applied to my usb-next branch.  Thanks for redoing this many
times and sticking with it.

greg k-h
