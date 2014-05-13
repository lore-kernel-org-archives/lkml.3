Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002AbaEML5f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:57:35 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59098 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbaEML5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:57:34 -0400
Message-ID: <537208A9.4020507@ti.com>
Date: Tue, 13 May 2014 17:27:29 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daniel Mack <zonque@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/5] Add support for SW babble Control
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com> <5371EA01.3080307@gmail.com>
In-Reply-To: <5371EA01.3080307@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/13/2014 3:16 PM, Daniel Mack wrote:
> Hi George,
>
> On 05/13/2014 10:31 AM, George Cherian wrote:
>> Series add support for SW babble control logic found in
>> new silicon versions of AM335x. Runtime differentiation of
>> silicon version is done by checking the BABBLE_CTL register.
>> For newer silicon the register default value read is 0x4 and
>> for older versions its 0x0.
> I tested this on a AM33xx platform and don't see any regression at
> least. This hardware has MUSB_BABBLE_CTL == MUSB_BABBLE_RCV_DISABLE.
> Anything particular you want me to test as well?
Are you seeing a wrapper restart done always or does it continue with a 
restart
after the babble condition?

You can check for
"musb_hdrc: setup fifo_mode 4" prints .
>
>
> Thanks,
> Daniel
>


-- 
-George

