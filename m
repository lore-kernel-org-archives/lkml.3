Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab3JCOhw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 10:37:52 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60267 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab3JCOhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 10:37:51 -0400
Message-ID: <524D813C.3070905@baylibre.com>
Date: Thu, 03 Oct 2013 16:37:48 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Dan Murphy <dmurphy@ti.com>
CC: Mugunthan V N <mugunthanvnm@ti.com>, tony@atomide.com,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: dts: AM33XX: add ethernet alias's for am33xx
References: <1380736713-24678-1-git-send-email-dmurphy@ti.com> <524CAEBE.5010305@ti.com>
In-Reply-To: <524CAEBE.5010305@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On 03/10/2013 01:39, Mugunthan V N wrote:
> On Wednesday 02 October 2013 12:58 PM, Dan Murphy wrote:
>> Set the alias for ethernet0 and ethernet1 so that uBoot
>> can set the MAC address appropriately.
>>
>> Currently uBoot cannot find the alias and there for does not set the
>> MAC address.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>
> Tested this with beagle bone black.
>
> Tested-by: Mugunthan V N <mugunthanvnm@ti.com>
>
> Regards
> Mugunthan V N

Thanks, pulled in my for_3.13/dts branch.

Regards,
Benoit
