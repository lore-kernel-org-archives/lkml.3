Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaL2NSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 08:18:21 -0500
Received: from arrowlinuxcloud.com ([192.198.192.26]:45126 "EHLO
	gains.arrowlinuxcloud.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751877AbaL2NSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 08:18:18 -0500
X-Greylist: delayed 3995 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Dec 2014 08:18:18 EST
User-Agent: Microsoft-MacOutlook/14.3.9.131030
Date: Mon, 29 Dec 2014 17:41:32 +0530
Subject: Re: [PATCH 3/3] Staging: comedi: fix space and 80 char coding style
 issue
From: Pankaj Saraf <pankaj.saraf@nektech.in>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        jitendra kumar khasdev <jkhasdev@gmail.com>
CC: <gregkh@linuxfoundation.org>, <abbotti@mev.co.uk>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>
Message-ID: <D0C741E6.3D64%pankaj.saraf@nektech.in>
Thread-Topic: [PATCH 3/3] Staging: comedi: fix space and 80 char coding style
 issue
References: <1419803085-9441-1-git-send-email-jkhasdev@gmail.com>
 <20141229070712.GD3749@sudip-PC>
In-Reply-To: <20141229070712.GD3749@sudip-PC>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gains.arrowlinuxcloud.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - nektech.in
X-Get-Message-Sender-Via: gains.arrowlinuxcloud.com: authenticated_id: pankaj.saraf@nektech.in
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jitendra,

You have to make 2 different changes so that the description of the change
can clearly be associated to change-number. Thanks!

Regards
Pankaj Saraf
NEKTech Research Labs, Bhopal (M.P.) - India

On 29/12/14 12:37 pm, "Sudip Mukherjee" <sudipm.mukherjee@gmail.com> wrote:

>On Mon, Dec 29, 2014 at 03:14:45AM +0530, jitendra kumar khasdev wrote:
>> This is a patch to the s626.c file that fixes up spcae and maximum
>> character limit warning found by the checkpatch.pl tool
>
>you are doing two different kind of changes in this patch. it should be
>in two different patches. One patch should do only one type of change.
>
>thanks
>sudip
>
>> 
>> Signed-off-by: Jitendra Kumar Khasdev  <jkhasdev@gmail.com>
>> ---
>>  drivers/staging/comedi/drivers/s626.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>> 
>> diff --git a/drivers/staging/comedi/drivers/s626.c
>>b/drivers/staging/comedi/drivers/s626.c
>> index 14932c5..77f715b 100644
>> --- a/drivers/staging/comedi/drivers/s626.c
>> +++ b/drivers/staging/comedi/drivers/s626.c
>> @@ -118,7 +118,7 @@ static void s626_mc_enable(struct comedi_device
>>*dev,
>>  static void s626_mc_disable(struct comedi_device *dev,
>>  			    unsigned int cmd, unsigned int reg)
>>  {
>> -	writel(cmd << 16 , dev->mmio + reg);
>> +	writel(cmd << 16, dev->mmio + reg);
>>  	mmiowb();
>>  }
>>  
>> @@ -2534,7 +2534,8 @@ static int s626_initialize(struct comedi_device
>>*dev)
>>  	for (i = 0; i < 2; i++) {
>>  		writel(S626_I2C_CLKSEL, dev->mmio + S626_P_I2CSTAT);
>>  		s626_mc_enable(dev, S626_MC2_UPLD_IIC, S626_P_MC2);
>> -		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc, 0);
>> +		ret = comedi_timeout(dev, NULL, NULL, s626_i2c_handshake_eoc,
>> +		0);
>>  		if (ret)
>>  			return ret;
>>  	}
>> -- 
>> 1.9.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


