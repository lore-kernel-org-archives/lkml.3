Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658AbaFZIfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 04:35:12 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38161 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752104AbaFZIfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 04:35:10 -0400
Message-ID: <53ABDA9A.8000108@ti.com>
Date: Thu, 26 Jun 2014 14:02:26 +0530
From: Sricharan R <r.sricharan@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <rnayak@ti.com>,
        <linux@arm.linux.org.uk>, <tglx@linutronix.de>, <jason@lakedaemon.net>,
        <joe@perches.com>, Benoit Cousson <bcousson@baylibre.com>
Subject: Re: [PATCH V4 2/2] arm: dts: dra7: add crossbar device binding
References: <1403767532-19290-1-git-send-email-r.sricharan@ti.com> <1403767532-19290-3-git-send-email-r.sricharan@ti.com> <20140626074417.GF28884@atomide.com>
In-Reply-To: <20140626074417.GF28884@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Thursday 26 June 2014 01:14 PM, Tony Lindgren wrote:
> * Sricharan R <r.sricharan@ti.com> [140626 00:29]:
>> From: R Sricharan <r.sricharan@ti.com>
>>
>> There is a IRQ crossbar device in the soc, which
>> maps the irq requests from the peripherals to the
>> mpu interrupt controller's inputs. The Peripheral irq
>> requests are connected to only one crossbar
>> input and the output of the crossbar is connected to only one
>> controller's input line. The crossbar device is used to map
>> a peripheral input to a free mpu's interrupt controller line.
>>
>> Here, adding a new crossbar device node and replacing all the peripheral
>> interrupt numbers with its fixed crossbar input lines.
> 
> I think these two patches need to be a single patch to avoid
> breaking booting for git bisect inbetween these patches?
  This does not cause booting issues. irq_desc gets allocated linearly,
   but that does not create boot issues.

Regards,
 Sricharan
  

