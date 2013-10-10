Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392Ab3JJTBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 15:01:42 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51023 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084Ab3JJTBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 15:01:40 -0400
Message-ID: <5256F97C.9080101@ti.com>
Date: Thu, 10 Oct 2013 14:01:16 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: =?ISO-8859-1?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        Rajendra Nayak <rnayak@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: dts: omap4-panda-es: Do not reset gpio1
References: <1381313521-10422-1-git-send-email-rnayak@ti.com> <1381423481-5920-1-git-send-email-nm@ti.com> <20131010164702.GF29913@atomide.com>
In-Reply-To: <20131010164702.GF29913@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 11:47 AM, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [131010 09:53]:
>> Do not reset GPIO1 at boot-up because GPIO 7 in GPIO1 block is used on
>> OMAP4460 PandaBoard-ES to select voltage register in TPS62361 which
>> supplies VDD_MPU.
>>
>> Without this, OMAP4460 PandaBoard-ES boards fail to boot-up because
>> MPU voltage switches over to VSET0 voltage value (boot voltage) which
>> is not sufficient to operate the device at OPP100.
> 
> Is this needs as a fix for the -rc series?

Nope, this is not a regression recently introduced, has been in since
day one of Panda-ES support. Further, we still have decision pending
on the dependent series from Rajendra[1] - will be good to see it go
in along with AM335x-EVM.


[1] http://marc.info/?t=138131368300005&r=1&w=2

-- 
Regards,
Nishanth Menon
