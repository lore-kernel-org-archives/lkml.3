Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab3KUStA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 13:49:00 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55257 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753057Ab3KUSs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 13:48:58 -0500
Message-ID: <528E5596.7090606@wwwdotorg.org>
Date: Thu, 21 Nov 2013 11:48:54 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alex Courbot <acourbot@nvidia.com>, Russell King <linux@arm.linux.org.uk>
CC: Olof Johansson <olof@lixom.net>, Tomasz Figa <t.figa@samsung.com>,
        Dave Martin <Dave.Martin@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/7] ARM: support for Trusted Foundations secure monitor
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com>	<52828EF5.6090909@wwwdotorg.org>	<CAOesGMhatp9ZQr=eTCtQ_9a_E9LXKdTCzJd+P7Sy9Ut9wtvnsA@mail.gmail.com>	<5282E068.1070608@nvidia.com> <CAOesGMgcvTFD4u9b7T5HNhuJe_PQyV25Ei++v8hG8AsY_rOdyw@mail.gmail.com>
In-Reply-To: <CAOesGMgcvTFD4u9b7T5HNhuJe_PQyV25Ei++v8hG8AsY_rOdyw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Russell, a question for you at the bottom)

On 11/13/2013 10:57 AM, Olof Johansson wrote:
> On Tue, Nov 12, 2013 at 6:14 PM, Alex Courbot <acourbot@nvidia.com> wrote:
>> On 11/13/2013 05:38 AM, Olof Johansson wrote:
...
>>> I pinged Russell, and he brought up the fact that there were earlier
>>> requests to move it to drivers/firmware. It would make sense to try to
>>> get that done before merging, especially if you anticipate someone
>>> using TF on 64-bit platforms.
>>
>> IIRC when we discussed this point your last comment was as follows:
> 
> Touche. :) Thanks for the reminder.
> 
>> On Tue, Oct 29, 2013 at 6:55 AM, Olof Johansson <olof@lixom.net> wrote:
>>> I think we can probably merge this under arch/arm now, and when we
>>> figure out what needs to be common with ARM64 we can move it out to a
>>> good location. It might be that mostly just a header file with ABI
>>> conventions needs to be shared, not actual implementation, for
>>> example.
>>
>> So I thought we agreed on that. If in the end we prefer to move the ARM
>> firmware interface into drivers/firmware, I'm fine with that too (Tomasz
>> also confirmed he would be ok with it) but I wonder if that would not be
>> somehow premature.
...
> Well, as I already said I'm ok with things going into arch/arm to
> start with, as long as Russell is.
...

Russell, the patch Alex sent to move firmware_ops into drivers/firmware
was rejected, so I don't think we can update this series to move the
code there instead.

So, are you OK with merging this series as-is, in arch/arm/firmware? If
you could ack the patch/series to indicate that, it would be awesome.
Thanks.
