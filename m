Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab3FRMdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:33:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:36873 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160Ab3FRMde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:33:34 -0400
Message-ID: <51C05382.8090805@ti.com>
Date: Tue, 18 Jun 2013 15:33:06 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <b-cousson@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] ARM: OMAP2+: dts: HACK: Provide alias to USB PHY
 clock
References: <1371553891-29364-1-git-send-email-rogerq@ti.com> <1371553891-29364-5-git-send-email-rogerq@ti.com> <20130618112342.GN5523@atomide.com>
In-Reply-To: <20130618112342.GN5523@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 02:23 PM, Tony Lindgren wrote:
> * Roger Quadros <rogerq@ti.com> [130618 04:17]:
>> Till the OMAP clocks are correctly defined in device tree, use
>> this temporary hack to provide clock alias to the USB PHY clocks.
>>
>> Without this, USB Host & Ethernet will not be functional with
>> device tree boots on Panda and uEVM.
> 
> Thanks, this looks OK to me to have USB working until we have the
> DT defined clock patches ready.
> 
> The $Subject needs updating though, just make it ARM: OMAP2+: and
> leave out the dts and hack from there.
> 

OK. will send v2 as i need to make another minor change in the panda dts file.

cheers,
-roger
