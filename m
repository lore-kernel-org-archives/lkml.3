Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753572AbbAEMrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:47:43 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:60704 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753135AbbAEMrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:47:41 -0500
Message-ID: <54AA87EB.1000004@ti.com>
Date: Mon, 05 Jan 2015 06:47:39 -0600
From: Nishanth Menon <nm@ti.com>
Reply-To: nm@ti.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@kernel.org>
CC: devicetree@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        linux-kernel@vger.kernel.org,
        =?windows-1252?Q?Beno=EEt_Cousson?= <bcousson@baylibre.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH V3] ARM: dts: am57xx-beagle-x15: Add GPIO controlled fan
 node
References: <1420309826-7904-1-git-send-email-nm@ti.com> <20150103233949.GA4108@earth.universe>
In-Reply-To: <20150103233949.GA4108@earth.universe>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2015 05:39 PM, Sebastian Reichel wrote:

> On Sat, Jan 03, 2015 at 12:30:26PM -0600, Nishanth Menon wrote:
>> [...]
>> +		gpio-fan,speed-map = <0    0
>> +				      13000 1>;
>> [...]
>
> iirc DT maintainers prefer this format:
>
> gpio-fan,speed-map = <0     0>,
>                       <13000 1>;
>
> This should result in the same .dtb, but is a bit easier to read.
>
yes indeed.. :( Thanks for catching it. will repost.

Regards,
Nishanth Menon

