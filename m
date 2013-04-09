Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935262Ab3DIIzV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 04:55:21 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54209 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935034Ab3DIIzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 04:55:19 -0400
Message-ID: <5163D769.1040401@ti.com>
Date: Tue, 9 Apr 2013 14:25:05 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: <rnayak@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, Keerthy <j-keerthy@ti.com>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH] ARM: OMAP4: HWMOD: make 'ocp2scp_usb_phy_phy_48m" as
 the main clock
References: <1365496101-7829-1-git-send-email-kishon@ti.com> <5163D72B.5040205@ti.com>
In-Reply-To: <5163D72B.5040205@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 09 April 2013 02:24 PM, Benoit Cousson wrote:
> Hi Kishon,
>
> On 04/09/2013 10:28 AM, Kishon Vijay Abraham I wrote:
>> commit 92702d (ARM: OMAP4: PM: fix PM regression introduced by recent
>> clock cleanup) makes the 'ocp2scp_usb_phy_phy_48m' as optional
>> functional clock causing regression in MUSB. But this 48MHz clock is a
>> mandatory clock for usb phy attached to ocp2scp and hence made as the main
>> clock for ocp2scp.
>
> It is a fix for 3.9-rcX?

Yeah.

Thanks
Kishon
