Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaDVX4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:56:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34979 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaDVX4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:56:51 -0400
Message-ID: <535701A3.5050309@ti.com>
Date: Tue, 22 Apr 2014 19:56:19 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: Re: [PATCH 0/2] net: Add Keystone NetCP ethernet driver support
References: <1398201675-17379-1-git-send-email-santosh.shilimkar@ti.com> <20140422150231.2e87b7eb@nehalam.linuxnetplumber.net>
In-Reply-To: <20140422150231.2e87b7eb@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 22 April 2014 06:02 PM, Stephen Hemminger wrote:
> On Tue, 22 Apr 2014 17:21:13 -0400
> Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> 
>> NetCP driver has a plug-in module architecture where each of the NetCP
>> sub-modules exist as a loadable kernel module which plug in to the netcp
>> core. These sub-modules are represented as "netcp-devices" in the dts
>> bindings. It is mandatory to have the ethernet switch sub-module for
>> the ethernet interface to be operational. Any other sub-module like the
>> PA is optional.
> 
> Where is the implementation of these modules. You need to include
> this as separate patch set. Also the hooks for these modules should all
> be EXPORT_SYMBOL_GPL() to disallow proprietary modules.
> 
There is no proprietary issue and all the hooks will be GPL. The plan is
to add them in another patch-set once the core driver gets merged. They need
some work to make them upstream ready.

Regards,
Santosh
