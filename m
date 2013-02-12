Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab3BLHsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 02:48:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44101 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab3BLHr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 02:47:58 -0500
Message-ID: <5119F39C.2080206@ti.com>
Date: Tue, 12 Feb 2013 09:47:40 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: Allow clock alias provision from device
 tree
References: <1360597464-8491-1-git-send-email-rogerq@ti.com> <20130211160752.GG1906@pengutronix.de>
In-Reply-To: <20130211160752.GG1906@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 06:07 PM, Sascha Hauer wrote:
> On Mon, Feb 11, 2013 at 05:44:23PM +0200, Roger Quadros wrote:
>> Currently on OMAP, it is not possible to specify a clock consumer
>> to any of the OMAP generated clocks using the device tree. This can pose
>> a problem for external devices that run off an OMAP clock as we
>> can't reliably provide a reference to the clock in the device tree.
> 
> There is an established way of providing clocks in the devicetree using
> the clocks/clock-names properties. Wouldn't it be better using this
> for OMAP aswell?
> 
I agree with you, but I'm not sure when this migration will be done.
Rajendra/Santosh might know better.

regards,
-roger

