Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab3FRNg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 09:36:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:48814 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368Ab3FRNgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 09:36:25 -0400
Message-ID: <51C06255.2080208@linutronix.de>
Date: Tue, 18 Jun 2013 15:36:21 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130518 Icedove/17.0.5
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>,
        Benoit Cousson <benoit.cousson@linaro.org>
CC: balbi@ti.com, Paul Walmsley <paul@pwsan.com>,
        Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Philip Avinash <avinashphilip@ti.com>
Subject: Re: [PATCH 2/4] ARM: dts: AM33XX: Add PWMSS device tree nodes
References: <1370526759-31163-1-git-send-email-bigeasy@linutronix.de> <1370526759-31163-3-git-send-email-bigeasy@linutronix.de> <51B89D78.6010906@linutronix.de> <20130612164026.GC22120@arwen.pp.htv.fi>
In-Reply-To: <20130612164026.GC22120@arwen.pp.htv.fi>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 06:40 PM, Felipe Balbi wrote:
> On Wed, Jun 12, 2013 at 06:10:32PM +0200, Sebastian Andrzej Siewior wrote:
>> On 06/06/2013 03:52 PM, Sebastian Andrzej Siewior wrote:
>>> From: Philip Avinash <avinashphilip@ti.com>
>>>
>>> Add PWMSS device tree nodes in relation with ECAP & EHRPWM DT nodes to
>>> AM33XX SoC family. Also populates device tree nodes for ECAP & EHRPWM by
>>> adding necessary properties like pwm-cells, base reg & set disabled as
>>> status.
>> Can someone please grab #2 till #4? Paul took just #1 as far as I can
>> tell.
> 
> DTS should be Benoit Cousson

So, Benoit. Would you please be so kind and pick up the dts pieces?

Sebastian
