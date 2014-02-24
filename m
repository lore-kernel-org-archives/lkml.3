Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaBXSO6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 13:14:58 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56131 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657AbaBXSO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 13:14:56 -0500
Message-ID: <530B8C00.8020001@ti.com>
Date: Mon, 24 Feb 2014 12:14:24 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>
CC: Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 0/7] omap hwspinlock dt support
References: <1389658764-39199-1-git-send-email-s-anna@ti.com> <52F9282B.5000702@ti.com>
In-Reply-To: <52F9282B.5000702@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, Ohad,

On 02/10/2014 01:27 PM, Suman Anna wrote:
> Mark,
>
> On 01/13/2014 06:19 PM, Suman Anna wrote:
>> Hi,
>>
>> This is an updated series mainly addressing Mark Rutland's comments
>> about hwlock specifier being always one-cell. The series adds the
>> support for #hwlock-cells property and adds a simple default OF
>> translate function.
>>
>> The DTS patches from previous series have already been merged, and
>> needs this property to be added. This is handled in a separate series
>> that only deals with OMAP hwspinlock DTS patches.
>>
>> The series, along with the DTS patches, is tested on top of v3.13-rc8
>> plus Tero's v13 clock DT series and Tony's 3.14 staged branches. The
>> validation on OMAP5, DRA7, AM437 requires Tero's series with couple of
>> additional base patches for AM43xx. AM43xx functionality needs a hwmod
>> fix [1] for creating the associated omap_device as well.
>>
>
> Can you please take a look at this series and give your ack on the
> bindings if you do not have any further comments? The only comments so
> far are from Bjorn on the OF helpers.
>

Gentle reminder, can you provide your acks/comments?

regards
Suman


