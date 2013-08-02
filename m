Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab3HBPZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 11:25:21 -0400
Received: from smtp131.dfw.emailsrvr.com ([67.192.241.131]:37017 "EHLO
	smtp131.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695Ab3HBPZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 11:25:18 -0400
Message-ID: <51FBCF21.3050807@calxeda.com>
Date: Fri, 02 Aug 2013 10:24:17 -0500
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Rob Herring <robherring2@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>
Subject: Re: [PATCH 4/5] sata, highbank: set tx_atten override bits
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com> <1374851518-4802-4-git-send-email-mark.langsdorf@calxeda.com> <20130726162231.GD3528@e106331-lin.cambridge.arm.com> <51F2C220.5040407@gmail.com> <20130730164231.GH29859@e106331-lin.cambridge.arm.com>
In-Reply-To: <20130730164231.GH29859@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 11:42 AM, Mark Rutland wrote:
> On Fri, Jul 26, 2013 at 07:38:24PM +0100, Rob Herring wrote:
>> On 07/26/2013 11:22 AM, Mark Rutland wrote:
>>> On Fri, Jul 26, 2013 at 04:11:57PM +0100, Mark Langsdorf wrote:
>>>> Some board designs do not drive the SATA transmit lines within the
>>>> specification. The ECME can provide override settings, on a per board
>>>> basis, to bring the transmit lines within spec. Read those settings
>>>> from the DTB and program them in.
>>>
>>> How variable is the use of this property going to be? Would it instead
>>> be possible to decide that this was necessary, and choose the
>>> appropriate values based on a compatible property?
>>
>> It is based on compliance testing of the particular board design. Basing
>> on a compatible property would not work in this case.
> 
> Ok. Could you clarify the u8/cell usage in the binding and amend the
> example please?

Yes, I'll do that. Thanks for the review.

--Mark Langsdorf
Calxeda, Inc.

