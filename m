Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266AbaETGYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 02:24:18 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56256 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaETGYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 02:24:17 -0400
Message-ID: <537AF4ED.9070106@ti.com>
Date: Tue, 20 May 2014 11:53:41 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <joelf@ti.com>,
        <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <arm@kernel.org>
Subject: Re: [PATCH] ARM: edma: Clean up and simplify the code around irq
 request
References: <1399965961-23739-1-git-send-email-peter.ujfalusi@ti.com> <5374AD6D.8090002@ti.com> <20140520055741.GR18956@quad.lixom.net>
In-Reply-To: <20140520055741.GR18956@quad.lixom.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 May 2014 11:27 AM, Olof Johansson wrote:
> On Thu, May 15, 2014 at 05:35:01PM +0530, Sekhar Nori wrote:
>> + ARM SoC team
>>
>> On Tuesday 13 May 2014 12:56 PM, Peter Ujfalusi wrote:
>>> Get the two interrupt line number at the same time by merging the two
>>> instance of if(node){}else{} places.
>>> replace the &pdev->dev with the already existing dev which makes it possible
>>> to collapse lines with devm_request_irq()
>>>
>>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
>>
>> Acked-by: Sekhar Nori <nsekhar@ti.com>
>>
>> Arnd, Olof, Kevin,
>>
>> Do you mind applying this directly for v3.16? I do not have anything
>> else queued ATM so not sending a pull request.
> 
> I see it was reposted today as part of a larger patch set with some
> question as to what it applies to.

That 13 patch set from Peter does not include this patch. If you have
not applied this directly, I will send everything together as a pull
request.

> Sekhar, if you just have one patch for us to apply, then feel free to
> resend it to use (git send-email --to=arm@kernel.org) and make it clear
> (below the --- separator) that you want us to apply it directly, and
> we'll be happy to do so.

Okay, will do so in future.

Thanks,
Sekhar
