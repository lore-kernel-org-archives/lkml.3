Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbaDIG57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:57:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54087 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaDIG55 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:57:57 -0400
Message-ID: <5344EF2F.8010106@ti.com>
Date: Wed, 9 Apr 2014 12:26:47 +0530
From: Mugunthan V N <mugunthanvnm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <linux@arm.linux.org.uk>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <balbi@ti.com>, <rogerq@ti.com>
Subject: Re: [PATCH] ARM: dts: am335x-boards: Fixup the usb control module
 address in respective Board files
References: <1396962477-9045-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1396962477-9045-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 April 2014 06:37 PM, George Cherian wrote:
> The USB Contol Module address was updated in am33xx.dtsi file
> by the following commit 8abcdd680d543fb582371e146e62ba9f2af8a816
> ARM: dts: am33xx: correcting dt node unit address for usb
>
> The same changes need to be done for respective board files.
> Without these changes USB wont be detected in any of the boards.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>

Acked-by: Mugunthan V N <mugunthanvnm@ti.com>
