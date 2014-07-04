Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaGDJF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 05:05:56 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35868 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbaGDJFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 05:05:54 -0400
Date: Fri, 4 Jul 2014 10:05:05 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Tegra USB probe order issue fix
Message-ID: <20140704090505.GD31812@leverpostej>
References: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404436179-10745-1-git-send-email-ttynkkynen@nvidia.com>
Thread-Topic: [PATCH v2 0/4] Tegra USB probe order issue fix
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 02:09:35AM +0100, Tuomas Tynkkynen wrote:
> Hi all,
> 
> Here's a second version of the probe order issue series. This time I've
> added the USB1 resets to the PHYs, thus replacing the really ugly parts
> with something slightly better. Old device trees will still probe
> successfully, but instead of this bugfix they'll get a dev_warn().

Given the binding looks sane and doesn't unnecessarily break existing
DTBs, for patches 1-3:

Acked-by: Mark Rutland <mark.rutland@arm.com>

Thanks,
Mark.
