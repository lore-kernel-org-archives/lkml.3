Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3GABM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 21:12:59 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:2549 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504Ab3GABM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 21:12:57 -0400
Message-ID: <51D0D73F.2060401@hp.com>
Date: Mon, 01 Jul 2013 09:11:27 +0800
From: ZhenHua <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130117 Thunderbird/19.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
References: <Pine.LNX.4.44L0.1306281018001.1047-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306281018001.1047-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 10:22 PM, Alan Stern wrote:
> On Fri, 28 Jun 2013, Li, Zhen-Hua (USL-China) wrote:
>
>> There was a problem, the warning "Controller not stopped yet".
>> And your last patch for this problem does a wrong thing:
>> It prevents all HP uhci devices from auto-stop, which make HP uhci
>> devices waste more
>> power.
> Do they really waste more power?  Have you measured this?
>
> Is CONFIG_PM enabled in the kernel configuration?
>
>> This is another new problem.
>>
>> I think this should be corrected, so I want to apply it.
> In the last email, you said that your patch did not make the machine
> act different.  Now you say that your patch makes the machine use less
> power.  Which statement is correct?
>
> Alan Stern
>
Let's make it clear:
I said "I don't have a machine that this makes action different",
it does not mean my patch "did not make the machine act different ".

There are many kinds of machines, I have never said "my patch does
not make ALL of them act different".




