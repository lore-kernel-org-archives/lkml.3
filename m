Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030290Ab3DSKyH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:54:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42904 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030265Ab3DSKyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:54:04 -0400
Message-ID: <51712208.5090403@ti.com>
Date: Fri, 19 Apr 2013 16:22:56 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <akpm@linux-foundation.org>, <rob@landley.net>,
        <broonie@opensource.wolfsonmicro.com>, <linux@arm.linux.org.uk>,
        <b-cousson@ti.com>, <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <eballetbo@gmail.com>,
        <santosh.shilimkar@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <swarren@nvidia.com>, <javier@dowhile0.org>,
        <linux-omap@vger.kernel.org>, <davem@davemloft.net>,
        <cesarb@cesarb.net>, <mchehab@redhat.com>
Subject: Re: [PATCH v3 0/6] Generic PHY Framework
References: <1363770725-13717-1-git-send-email-kishon@ti.com>
In-Reply-To: <1363770725-13717-1-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 3/20/2013 2:41 PM, Kishon Vijay Abraham I wrote:
> Added a generic PHY framework that provides a set of APIs for the PHY drivers
> to create/destroy a PHY and APIs for the PHY users to obtain a reference to
> the PHY with or without using phandle. To obtain a reference to the PHY
> without using phandle, the platform specfic intialization code (say from board
> file) should have already called phy_bind with the binding information. The
> binding information consists of phy's device name, phy user device name and an
> index. The index is used when the same phy user binds to mulitple phys.
> 
> This framework will be of use only to devices that uses external PHY (PHY
> functionality is not embedded within the controller).

>From a top level what you are doing looks closely related to External
connector (extcon).

I understand a connector is not the same as a phy, but it will still be
useful to know why extcon framework (or some extension of it) will not
suffice your needs.

You can probably note it in the cover-letter so folks like me get their
answer.

Thanks,
Sekhar
