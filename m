Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007AbaEPRcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:32:04 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51441 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbaEPRcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:32:00 -0400
Message-ID: <53764B6F.9030106@ti.com>
Date: Fri, 16 May 2014 12:31:27 -0500
From: Joel Fernandes <joelf@ti.com>
Reply-To: <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: <devicetree@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-doc@vger.kernel.org>, <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 2/5] ARM: edma: Get IP information from HW when booting
 with DT
References: <1399977032-26469-1-git-send-email-peter.ujfalusi@ti.com> <1399977032-26469-3-git-send-email-peter.ujfalusi@ti.com> <53748070.4080706@ti.com> <5374B34D.2060904@ti.com> <5374B7B8.4060604@ti.com>
In-Reply-To: <5374B7B8.4060604@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 07:48 AM, Sekhar Nori wrote:
> On Thursday 15 May 2014 06:00 PM, Peter Ujfalusi wrote:
> 
>> The second controller is not handled because in DT boot we only handle 1 cc as
>> far as I know. I don't know why, but this is how the DT support has been
>> written and used.
> 
> Its just because none of the platforms under heavy development use two
> controllers. Joel promised to work on it at some point ;)

Yeah, often things like that go down in priority when there aren't
users, and when other things on fire need to be tended to :-D

I think the next on-fire thing as far as EDMA goes would be to move out
into drivers/edma. I like Peter's series in that it probably is a step
forward there.

thanks,

-Joel

