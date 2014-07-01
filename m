Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbaGAPSq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 11:18:46 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:39996 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbaGAPSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 11:18:42 -0400
Message-ID: <53B2D151.60404@cogentembedded.com>
Date: Tue, 01 Jul 2014 19:18:41 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Peter Chen <peter.chen@freescale.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        =?ISO-8859-1?Q?Antoine_T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/12] usb: chipidea: add a generic driver
References: <1403606121-6368-1-git-send-email-antoine.tenart@free-electrons.com> <1403606121-6368-8-git-send-email-antoine.tenart@free-electrons.com> <20140627032506.GA18039@shlinux1.ap.freescale.net> <20140630133313.GA11880@kwain> <20140701002112.GA26146@shlinux1.ap.freescale.net> <53B27789.3090509@gmail.com> <20140701083007.GB26146@shlinux1.ap.freescale.net> <20140701104254.GD3427@piout.net>
In-Reply-To: <20140701104254.GD3427@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/01/2014 02:42 PM, Alexandre Belloni wrote:

>>>>> Well, there is nothing specific about the Berlin CI. Some subsystems
>>>>> use the 'generic' keyword in these cases. Do you see a particular reason
>>>>> I should use some Berlin related compatible here?

>>>> Not must, one suggestion is: can you change the compatible string
>>>> to "chipidea-usb-generic"?

>>> I don't know about ChipIdea/ARC/DW's product portfolio but I guess
>>> the compatible should also carry '2.0' or 'usb2' in it. Or we just
>>> use some version number like 'chipidea,ci13000' or 'chipidea,ci13xxx'.

>> The recommended format for compatible string is: "manufacturer,model",
>> I agree with "chipidea,ci13xxx", thanks.

> I think we should probably avoid using wildcards in the compatible
> string.

    I'm sure wildcards shouldn't be allowed there. :-)

WBR, Sergei

