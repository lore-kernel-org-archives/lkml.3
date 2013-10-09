Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab3JIRuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:50:06 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46570 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081Ab3JIRuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:50:03 -0400
Message-ID: <5255970F.1060307@ti.com>
Date: Wed, 9 Oct 2013 12:49:03 -0500
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Paul Walmsley <paul@pwsan.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCHv2 4/9] ARM: OMAP5: hwmod data: Add spinlock data
References: <cover.1379445653.git.s-anna@ti.com> <9812d9a19f9a52021dcae4b4fef50f10f2c21202.1379445653.git.s-anna@ti.com> <alpine.DEB.2.02.1310090712440.30199@utopia.booyaka.com>
In-Reply-To: <alpine.DEB.2.02.1310090712440.30199@utopia.booyaka.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/2013 02:12 AM, Paul Walmsley wrote:
> On Tue, 17 Sep 2013, Suman Anna wrote:
> 
>> Add the hwmod data for the spinlock IP in OMAP5 SoC.
>> This is needed to be able to enable the OMAP spinlock
>> support for OMAP5.
>>
>> Signed-off-by: Suman Anna <s-anna@ti.com>
> 
> Thanks, queued.  You can omit this one from future reposts of this series.
> 

Thanks. I will be reposting the series (soon), and will omit this patch
and the AM335 sysc patch in the repost.

regards
Suman

