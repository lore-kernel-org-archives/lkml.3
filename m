Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240Ab3KYWZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 17:25:43 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:52636 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab3KYWZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 17:25:41 -0500
Message-ID: <5293CE4E.3090401@ti.com>
Date: Mon, 25 Nov 2013 16:25:18 -0600
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] ARM: OMAP4: hwmod: add hwmod data for DES IP
References: <1385415876-12387-1-git-send-email-joelf@ti.com> <1385415876-12387-6-git-send-email-joelf@ti.com> <20131125221111.GU10023@atomide.com>
In-Reply-To: <20131125221111.GU10023@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2013 04:11 PM, Tony Lindgren wrote:
> * Joel Fernandes <joelf@ti.com> [131125 13:45]:
>> +
>> +static struct omap_hwmod_addr_space omap4_des_addrs[] = {
>> +	{
>> +		.pa_start	= 0x480A4000,
>> +		.pa_end		= 0x481A4000,
>> +		.flags		= ADDR_TYPE_RT
>> +	},
>> +	{ }
>> +};
> 
> Let's not add new address space entries. The address
> space should be already coming from device tree.
> 
Sorry, yes. that's true - I'll drop these.

thanks,

-Joel

