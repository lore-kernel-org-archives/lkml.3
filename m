Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaGILBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 07:01:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40710 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbaGILBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 07:01:31 -0400
Message-ID: <53BD208E.6000507@ti.com>
Date: Wed, 9 Jul 2014 16:29:26 +0530
From: Keerthy <a0393675@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Keerthy <j-keerthy@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <mark.rutland@arm.com>, <galak@codeaurora.org>, <robh+dt@kernel.org>,
        <linux@arm.linux.org.uk>, <balbi@ti.com>, <kishon@ti.com>,
        <broonie@kernel.org>
Subject: Re: [PATCH v3 0/7] ARM: dts: AM43x: Add devcice tree nodes
References: <1404884193-20580-1-git-send-email-j-keerthy@ti.com> <20140709083114.GH28884@atomide.com>
In-Reply-To: <20140709083114.GH28884@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 July 2014 02:01 PM, Tony Lindgren wrote:
> * Keerthy <j-keerthy@ti.com> [140708 22:40]:
>> The patch series adds the device tree nodes and the corresponding
>> documentation. The series also enabled tps65218 config options
>> in the omap2plus_defconfig.
>>
>> The series is boot tested on both AM43x-epos-evm and AM437x-gp-evm.
> Are the .dts changes safe to apply separately without breaking
> anything?
Tony,

Patch 1/7 had to be re-based on Mark's latest branch for tps65218.
Other patches can be taken as is. These patches are boot tested on
both am437x-gp-evm and am43x-epos-evm.

> Regards,
>
> Tony

Regards,
Keerthy
