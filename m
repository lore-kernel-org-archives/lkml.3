Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaHVTuy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 15:50:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:46773 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238AbaHVTux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 15:50:53 -0400
Message-ID: <53F79F01.6090804@ti.com>
Date: Fri, 22 Aug 2014 15:50:25 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Stephen Hemminger <stephen@networkplumber.org>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <sandeep_n@ti.com>
Subject: Re: [PATCH v2 2/3] net: Add Keystone NetCP ethernet driver
References: <1408115562-22487-1-git-send-email-santosh.shilimkar@ti.com>	<1408115562-22487-3-git-send-email-santosh.shilimkar@ti.com> <20140821194838.32f2c3f1@uryu.home.lan>
In-Reply-To: <20140821194838.32f2c3f1@uryu.home.lan>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2014 10:48 PM, Stephen Hemminger wrote:
> On Fri, 15 Aug 2014 11:12:41 -0400
> Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:
> 
>> NetCP driver has a plug-in module architecture where each of the NetCP
>> sub-modules exist as a loadable kernel module which plug in to the netcp
>> core. These sub-modules are represented as "netcp-devices" in the dts
>> bindings. It is mandatory to have the ethernet switch sub-module for
>> the ethernet interface to be operational. Any other sub-module like the
>> PA is optional.
> 
> What are you doing to prevent/discourage proprietary binary only
> sub-modules?
> 
Not sure if you mistook this infrastructure as a replacement for the
kernel module. The sub modules are traditional kernel modules that
just registers into the NetCP framework. Kernel module infrastructure
already discourages the proprietary binary only sub-modules.

Regards,
Santosh
