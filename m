Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762737Ab3JQUJP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:09:15 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54229 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759409Ab3JQUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:09:12 -0400
Message-ID: <526043E3.3070302@baylibre.com>
Date: Thu, 17 Oct 2013 22:09:07 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Nishanth Menon <nm@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>
CC: mark.rutland@arm.com, devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, tony@atomide.com,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org,
        rob.herring@calxeda.com, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: omap5-uevm: remove always_on, boot_on from
 smps10_out1
References: <1381402195-29257-1-git-send-email-kishon@ti.com> <525E9206.9010501@ti.com> <525E9434.1090006@ti.com>
In-Reply-To: <525E9434.1090006@ti.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 16/10/2013 15:27, Nishanth Menon wrote:
> On 10/16/2013 08:17 AM, Kishon Vijay Abraham I wrote:
>> Benoit,
>>
>> On Thursday 10 October 2013 04:19 PM, Kishon Vijay Abraham I wrote:
>>> smps10 should be enabled only in the case of host mode. So stop
>>> doing always_on, boot_on from smps10_out1. The driver will enable it in host
>>> mode.
>>
>> Can you take this patch too?
>
> Acked-by: Nishanth Menon <nm@ti.com>

I've just applied it.

Thanks,
Benoit


-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
