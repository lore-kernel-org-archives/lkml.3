Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbaE1AYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:24:55 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60461 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbaE1AYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:24:54 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5384D84B.6000904@yahoo.fr>
References: <1400621236-20423-1-git-send-email-tremyfr@yahoo.fr> <5383A3BF.1060506@metafoo.de> <5384D84B.6000904@yahoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [PATCH v2] iio: add support of the max1027
From: Jonathan Cameron <jic23@kernel.org>
Date: Wed, 28 May 2014 02:24:47 +0200
To: trem <tremyfr@yahoo.fr>, Lars-Peter Clausen <lars@metafoo.de>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        armadeus-forum@lists.sourceforge.net, knaack.h@gmx.de
Message-ID: <70f677a6-7561-4038-9ac3-fa2f17087c10@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On May 27, 2014 8:24:11 PM CEST, trem <tremyfr@yahoo.fr> wrote:
>Hi,
>
>
>On 26/05/14 22:27, Lars-Peter Clausen wrote:
>> On 05/20/2014 11:27 PM, Philippe Reynes wrote:
>>> This driver add partial support of the
>>> maxim 1027/1029/1031. Differential mode is not
>>> supported.
>>>
>>> It was tested on armadeus apf27 board.
>>>
>>> Signed-off-by: Philippe Reynes<tremyfr@yahoo.fr>
>>> ---
>>>    .../devicetree/bindings/iio/adc/max1027-adc.txt    |   21 +
>>>    drivers/staging/iio/adc/Kconfig                    |    9 +
>>>    drivers/staging/iio/adc/Makefile                   |    1 +
>>>    drivers/staging/iio/adc/max1027.c                  |  553
>++++++++++++++++++++
>>
>> New drivers should go into drivers/iio/
>
>I'll be pleased to add this driver in drivers/iio/
>Everybody agrees ??
I do. 

Jonathan
>  
>>>    4 files changed, 584 insertions(+), 0 deletions(-)
>>>    create mode 100644
>Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
>>>    create mode 100644 drivers/staging/iio/adc/max1027.c
>> [...]
>>
>
>Regards,
>Philippe

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
