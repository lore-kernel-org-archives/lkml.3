Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419AbaBYObK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:31:10 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:57150 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaBYObJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:31:09 -0500
Message-ID: <530CA928.7000707@epfl.ch>
Date: Tue, 25 Feb 2014 15:31:04 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: twl6040: Small clean-ups
References: <1393334900-29740-1-git-send-email-florian.vaussard@epfl.ch> <530CA6BA.1000405@ti.com> <20140225142705.GC9195@lee--X1>
In-Reply-To: <20140225142705.GC9195@lee--X1>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 02/25/2014 03:27 PM, Lee Jones wrote:
>>> Here is two cleanups patches for the TWL6040 audio codec. The first
>>> one checks for an error when reading the revision register (first read
>>> in the probe path). The second removes a duplicate I2C writes.
>>>
>>> Regards,
>>> Florian
>>
>> To both:
>> Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> Applied both with Peter's Ack.
> 

Thanks!

Florian
