Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbaE1SuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:50:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38670 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbaE1St7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:49:59 -0400
Date: Wed, 28 May 2014 11:53:34 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Satish Patel <satish.patel@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        rob@landley.net, tony@atomide.com, grant.likely@linaro.org,
        robh+dt@kernel.org
Subject: Re: [PATCH v3 1/5] sc_phy:SmartCard(SC) PHY interface to SC
 controller
Message-ID: <20140528185334.GA30763@kroah.com>
References: <1401267437-22489-1-git-send-email-satish.patel@ti.com>
 <1401267437-22489-2-git-send-email-satish.patel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401267437-22489-2-git-send-email-satish.patel@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 02:27:13PM +0530, Satish Patel wrote:
> SmartCard controller uses this interface to communicate with
> SmartCard via PHY
> 
> Some SmartCard PHY has multiple slots for cards.
> This inerface also enables controller to communicate
> with one or more SmartCard connected over phy.
> 
> interface structure includes following APIs
> - set/get config
> - activate/deactivate smart card
> - warm reset
> - register_notify (for card insert/remove/overheat)
> - unregister_notify
> 
> Signed-off-by: Satish Patel <satish.patel@ti.com>
> ---
>  Documentation/sc_phy.txt |  171 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/sc_phy.h   |  136 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 307 insertions(+)
>  create mode 100644 Documentation/sc_phy.txt
>  create mode 100644 include/linux/sc_phy.h

These are .h files, but where is the "api" functions that use
these structures defined at?

confused,

greg k-h
