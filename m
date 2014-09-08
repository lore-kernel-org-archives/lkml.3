Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaIHXMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:12:10 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:19465 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755102AbaIHXMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:12:07 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/VWSmpg/8cGfIPd0Kht/+A
Date: Mon, 8 Sep 2014 16:12:01 -0700
From: Tony Lindgren <tony@atomide.com>
To: Nishanth Menon <nm@ti.com>
Cc: Keerthy <a0393675@ti.com>, Keerthy <j-keerthy@ti.com>,
        mark.rutland@arm.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        galak@codeaurora.org, Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH 0/2] ARM: dts: dra72-evm: Add i2c1 and tps65917 nodes
Message-ID: <20140908231200.GR3238@atomide.com>
References: <1406528334-4415-1-git-send-email-j-keerthy@ti.com>
 <53D5EE21.1040000@ti.com>
 <53D61643.4070005@ti.com>
 <53EA0A26.1050301@ti.com>
 <20140908200443.GA24258@kahuna>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908200443.GA24258@kahuna>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Nishanth Menon <nm@ti.com> [140908 13:05]:
> On 18:05-20140812, Keerthy wrote:
> > On Monday 28 July 2014 02:52 PM, Keerthy wrote:
> > >On Monday 28 July 2014 12:00 PM, Lokesh Vutla wrote:
> > >>On Monday 28 July 2014 11:48 AM, Keerthy wrote:
> > >>>The patch series adds i2c1 and tps65917 and related nodes.
> > >>>The patch series is boot tested on DRA72-EVM.
> > >>>
> > >>>Thanks to Lokesh <lokeshvutla@ti.com> for testing the series.
> > >
> > >Correcting the 'to' list.
> > 
> > Hi Tony,
> > 
> > If there are no comments could you please pull these two patches?
> 
> With 3.17-rc4, I tested this series:
> dra72-evm-before: http://paste.ubuntu.org.cn/1496342
> dra72-evm-after: http://paste.ubuntu.org.cn/1496341
> 
> Patches:
> https://patchwork.kernel.org/patch/4632391/
> https://patchwork.kernel.org/patch/4632421/
> 
> Could we pick these with 3.18?
> 
> Please free to add:
> 
> Tested-by: Nishanth Menon <nm@ti.com>

OK applying into omap-for-v3.18/dt thanks.

Regards,

Tony
