Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab3CYKxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:53:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53857 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756146Ab3CYKxv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:53:51 -0400
Message-ID: <51502D29.1010307@ti.com>
Date: Mon, 25 Mar 2013 16:25:37 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Will Deacon <will@willdeacon.co.uk>, Lokesh Vutla <lokeshvutla@ti.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if system
 supports 'has_ossr'
References: <51407120.7030709@ti.com> <51417E58.5050501@ti.com> <20130315050014.GA15706@tiny-lites> <5146B972.1010002@ti.com> <20130318150724.GC28585@mudshark.cambridge.arm.com> <514736D4.4070906@ti.com> <20130318170649.GA29585@mudshark.cambridge.arm.com> <5148082A.3060503@ti.com> <20130319102803.GB22452@mudshark.cambridge.arm.com> <515014A4.5020504@ti.com> <20130325104910.GE12110@mudshark.cambridge.arm.com>
In-Reply-To: <20130325104910.GE12110@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013 04:19 PM, Will Deacon wrote:
> On Mon, Mar 25, 2013 at 09:11:00AM +0000, Santosh Shilimkar wrote:
>> Will,
> 
> Hi Santosh,
> 
>> Are you going to send the patch for 3.9-rcx ? As I said before without the
>> patch OMAP4 CPUILDE is unusable because of that debug noise and hence it
>> will be good to get that patch in
> 
> It's in Russell's tree, so should be queued for mainline fairly soon.
> 
Thanks Will !!

Regards
Santosh

