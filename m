Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaE0SYP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:24:15 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:20183 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbaE0SYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:24:12 -0400
Message-ID: <5384D84B.6000904@yahoo.fr>
Date: Tue, 27 May 2014 20:24:11 +0200
From: trem <tremyfr@yahoo.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120623 Thunderbird/10.0.5
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        armadeus-forum@lists.sourceforge.net, jic23@kernel.org,
        knaack.h@gmx.de
Subject: Re: [PATCH v2] iio: add support of the max1027
References: <1400621236-20423-1-git-send-email-tremyfr@yahoo.fr> <5383A3BF.1060506@metafoo.de>
In-Reply-To: <5383A3BF.1060506@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On 26/05/14 22:27, Lars-Peter Clausen wrote:
> On 05/20/2014 11:27 PM, Philippe Reynes wrote:
>> This driver add partial support of the
>> maxim 1027/1029/1031. Differential mode is not
>> supported.
>>
>> It was tested on armadeus apf27 board.
>>
>> Signed-off-by: Philippe Reynes<tremyfr@yahoo.fr>
>> ---
>>    .../devicetree/bindings/iio/adc/max1027-adc.txt    |   21 +
>>    drivers/staging/iio/adc/Kconfig                    |    9 +
>>    drivers/staging/iio/adc/Makefile                   |    1 +
>>    drivers/staging/iio/adc/max1027.c                  |  553 ++++++++++++++++++++
>
> New drivers should go into drivers/iio/

I'll be pleased to add this driver in drivers/iio/
Everybody agrees ??
  
>>    4 files changed, 584 insertions(+), 0 deletions(-)
>>    create mode 100644 Documentation/devicetree/bindings/iio/adc/max1027-adc.txt
>>    create mode 100644 drivers/staging/iio/adc/max1027.c
> [...]
>

Regards,
Philippe
