Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757649AbaGAIzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 04:55:44 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:60667 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaGAIzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 04:55:42 -0400
Message-ID: <53B27789.3090509@gmail.com>
Date: Tue, 01 Jul 2014 10:55:37 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
To: Peter Chen <peter.chen@freescale.com>,
        =?ISO-8859-1?Q?Antoine_T=E9n?= =?ISO-8859-1?Q?art?= 
	<antoine.tenart@free-electrons.com>
CC: alexandre.belloni@free-electrons.com, thomas.petazzoni@free-electrons.com,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com> <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com> <20140627032506.GA18039@shlinux1.ap.freescale.net> <20140630133313.GA11880@kwain> <20140701002112.GA26146@shlinux1.ap.freescale.net>
In-Reply-To: <20140701002112.GA26146@shlinux1.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2014 02:21 AM, Peter Chen wrote:
> On Mon, Jun 30, 2014 at 03:33:13PM +0200, Antoine Ténart wrote:
>> On Fri, Jun 27, 2014 at 11:25:07AM +0800, Peter Chen wrote:
>>> On Tue, Jun 24, 2014 at 12:35:16PM +0200, Antoine Ténart wrote:
>>>> +
>>>> +static const struct of_device_id ci_hdrc_generic_of_match[] = {
>>>> +	{ .compatible = "chipidea-usb" },
>>>> +	{ }
>>>> +};
>>>
>>> Even as a generic driver, you can also use your own compatible string.
>>
>> Well, there is nothing specific about the Berlin CI. Some subsystems
>> use the 'generic' keyword in these cases. Do you see a particular reason
>> I should use some Berlin related compatible here?
>
> Not must, one suggestion is: can you change the compatible string
> to "chipidea-usb-generic"?

I don't know about ChipIdea/ARC/DW's product portfolio but I guess
the compatible should also carry '2.0' or 'usb2' in it. Or we just
use some version number like 'chipidea,ci13000' or 'chipidea,ci13xxx'.

Sebastian

