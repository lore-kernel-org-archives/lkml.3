Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684AbaLEEUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 23:20:09 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:60302 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933462AbaLEEUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 23:20:07 -0500
MIME-Version: 1.0
In-Reply-To: <20141204183242.GJ7944@katana>
References: <1417610126-7957-1-git-send-email-harinik@xilinx.com>
	<1417610126-7957-2-git-send-email-harinik@xilinx.com>
	<20141204183242.GJ7944@katana>
Date: Fri, 5 Dec 2014 09:50:04 +0530
Message-ID: <CAFcVEC+mpfjYB2K5eci-BFfjyKXvbxOOBVX_CH=ck1xJ+V9goQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] i2c: cadence: Handle > 252 byte transfers
From: Harini Katakam <harinikatakamlinux@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?Q?S=C3=B6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vishnum@xilinx.com" <vishnum@xilinx.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 5, 2014 at 12:02 AM, Wolfram Sang <wsa@the-dreams.de> wrote:
>
>> +             /*
>> +              * If the device is sending data If there is further
>> +              * data to be sent. Calculate the available space
>> +              * in FIFO and fill the FIFO with that many bytes.
>> +              */
>
> This comment looks broken. In general, I think there should be more
> comments explaining why things have to be done this way.
>

There's some grammatical errors here. Let me correct it and add more
comments.

Regards,
Harini
