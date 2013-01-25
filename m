Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab3AYNH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 08:07:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20169 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932292Ab3AYNHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 08:07:21 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=fGM4yXGx12wA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=RaCtCyzfOO0A:10 a=DMzc6ZLNQwBmPUYpvbkA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359119239.21576.213.camel@gandalf.local.home>
Subject: Re: [BUG] panda board locks up on boot
From: Steven Rostedt <rostedt@goodmis.org>
To: Mats Liljegren <mats.liljegren@enea.com>
Cc: Igor Grinberg <grinberg@compulab.co.il>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Date: Fri, 25 Jan 2013 08:07:19 -0500
In-Reply-To: <0247700D01F14443B9209F90AD938CC52409708C@sestoex09.enea.se>
References: <1359082886.21576.199.camel@gandalf.local.home>
	 <51022FD2.8090101@compulab.co.il>
	 <0247700D01F14443B9209F90AD938CC52409708C@sestoex09.enea.se>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-25 at 08:43 +0000, Mats Liljegren wrote:
> Hi Steven,
> 
> Do you have CONFIG_CPU_FREQ enabled? As I posted earlier in
> linux-kernel forum ("Failed booting PandaBoard ES with Linux 3.8 RC4"
> two days ago) my PandaBoard ES hangs while booting with this option
> enabled. It works fine without it. I have not bisected it down to a
> single commit though.
> 

#
# CPU Frequency scaling
#
# CONFIG_CPU_FREQ is not set
CONFIG_CPU_IDLE=y
# CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
CONFIG_CPU_IDLE_GOV_LADDER=y
CONFIG_CPU_IDLE_GOV_MENU=y
CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED=y


I guess that's not the issue I have.

Thanks,

-- Steve


