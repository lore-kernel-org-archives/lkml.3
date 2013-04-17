Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936381Ab3DQTTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:19:05 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:35418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936043Ab3DQTTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:19:03 -0400
Message-ID: <516EF59E.3090907@ti.com>
Date: Wed, 17 Apr 2013 14:18:54 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>
CC: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: omap4-panda: Add LED support into the panda
 DTS files
References: <1366225778-6083-1-git-send-email-dmurphy@ti.com> <1366225778-6083-2-git-send-email-dmurphy@ti.com>
In-Reply-To: <1366225778-6083-2-git-send-email-dmurphy@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.24.16.90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/17/2013 02:09 PM, Dan Murphy wrote:
> The GPIO for LED D1 on the omap4-panda a1-a3 rev and the omap4-panda-es
> are different.
> 
> Abstract away the pinmux and the LED definitions for the two boards.

Just a heads-up but you should base this upon Benoit's for_3.10 branch
[1] as there is now a omap4-panda-common.dtsi where the led stuff
currently resides.

Cheers
Jon

[1]
http://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.10/dts
