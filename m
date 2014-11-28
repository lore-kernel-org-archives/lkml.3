Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751212AbaK1UQY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 15:16:24 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:42863 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaK1UQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 15:16:21 -0500
Message-ID: <5478D810.3060101@cogentembedded.com>
Date: Fri, 28 Nov 2014 23:16:16 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
CC: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/17] net2280: Remove restart_dma inline function definition
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com> <1417182662-7405-7-git-send-email-ricardo.ribalda@gmail.com> <54788AC3.9090808@cogentembedded.com> <CAPybu_1R+L91kGTG1sHhKiChd3v7=wa70v2VWDrQ-TH1FYyxSQ@mail.gmail.com>
In-Reply-To: <CAPybu_1R+L91kGTG1sHhKiChd3v7=wa70v2VWDrQ-TH1FYyxSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 06:21 PM, Ricardo Ribalda Delgado wrote:

> Thanks for reviewing. I will fix it and resend it on the next version
> of the patchset to avoid spamming the ML

> I guess it is ok to add your Reviewed-by

    Yes, if you like.

> Thanks!

    Not at all. :-)

[...]

>> On 11/28/2014 04:50 PM, Ricardo Ribalda Delgado wrote:

>>> restart_dma is not used before it is declaration. Therefore we can

>>     s/it is/its/.

    Also s/declaration/definition/.

>>> remove this definition.

>>     You're removing the declaration, not definition.

WBR, Sergei

