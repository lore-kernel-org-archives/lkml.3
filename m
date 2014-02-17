Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaBQUuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:50:39 -0500
Received: from nm39.bullet.mail.ne1.yahoo.com ([98.138.229.32]:22052 "HELO
	nm39.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752667AbaBQUuh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:50:37 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 780258.24265.bm@omp1096.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=a+wKaVjyMzuwBHWGUmHb7M2N2dwlKs+g/OXn/SLsD9aYg49amXQwsTYdJ25jYdmQxh6vln0ZhlWypD3USulxBvvhA0encn77zlMahmLpJg164cdjNyXO+RUSTY2zAVxs6XsnDoHhV8+1ZB4LbeUXFkIf6BLiMpu7u0pxnaYynVQ=;
X-YMail-OSG: ff.dR5IVM1ngpZIY.iDYsdhPF46c43NiXmxUTvLmyQ4v3ld
 M6W6Ot4zJ9qmOgesms.XYazFHENPJ_hI_9AAdGke68ehECy28YlZoTokbYR8
 QJcj43N3NJ3jpZCrldLysawS7xxoKqtONFdVPtoE7GUm9Pu8zFoKCebbNjIF
 4ceMP_L4wwFi7EwWt3n1c4FCuyIye9DF_ZtCcnP9PFOPNMksiTYK_ngjPdog
 o3DtpH8GQzq_Le0w6WyY8cLXuM5L.LFLCLk75Cc3ig.FX.VoAEKTrAvnFXsp
 SgSO3e9nlHpCwgFZ0TVQR8EP9yEDoMJPPG.W5dktIsQ0.joOmVs2XdWhYlGW
 RvjcQm06Z9vu3i9KvxAwb3.fQdysbeylATQF2.5FLEAqL2ZAwDe4Vy8GammZ
 BFMExjrNLstGmH84VkVlRw_K0GQv5FsflkjdDsXENdcjazbGH4_nWTWYLsRZ
 kYLmFj_nU7DtEPBZdtIz8mMJNJL8k2cWRXRm8Mkrfs1aEdf80ZIH3i6_nc2F
 Tghy3nvdZMYMHf2fFV5_5kUFMvvyZiFs57S7P
X-Rocket-MIMEInfo: 002.001,Pk9uIE1vbmRheSwgRmVicnVhcnkgMTcsIDIwMTQgNzoxOCBBTSwgSWFuIEFiYm90dCA8YWJib3R0aUBtZXYuY28udWs.IHdyb3RlOgoKPj5PbiAyMDE0LTAyLTE2IDA4OjQxLCBDaGFzZSBTb3V0aHdvb2Qgd3JvdGU6Cj4.Cj4.IFRoaXMgcGF0Y2ggZm9yIGh3ZHJ2X2FwY2kwMzUuYyBjaGFuZ2VzIGEgcHJpbnRrKCkgY2FsbCB0byBhIGRldl9lcnIgY2FsbAo.PiBzaW5jZSB0aGlzIGlzIGdlbmVyYWxseSBwcmVmZXJyZWQuCj4.Cj4.IFNpZ25lZC1vZmYtYnk6IENoYXNlIFNvdXRod29vZCA8Y2hhc2Uuc291dGgBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com> <1392540082-26064-1-git-send-email-chase.southwood@yahoo.com> <53020BFE.9020400@mev.co.uk>
Message-ID: <1392670074.22877.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Mon, 17 Feb 2014 12:47:54 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 3/4] Staging: comedi: addi-data: convert printk() to dev_err()
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <53020BFE.9020400@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Monday, February 17, 2014 7:18 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-02-16 08:41, Chase Southwood wrote:
>>
>> This patch for hwdrv_apci035.c changes a printk() call to a dev_err call
>> since this is generally preferred.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>>   drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> index 90d5801..f02b714 100644
>> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> @@ -227,7 +227,7 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>>               ui_Command = ui_Command & 0xFFF819E2UL;
>>
>>           } else {
>> -            printk("\n The parameter for Timer/watchdog selection is in error\n");
>> +            dev_err(dev->class_dev, "\n The parameter for Timer/watchdog selection is in error\n");
>>               return -EINVAL;>>
>>           }
>>       }
>>
>
>It'd be great if you could get rid of the initial "\n " in the error 
>string too.
>

Excellent, thanks for the feedback.  I'll resend without that newline!

Thanks,
Chase

