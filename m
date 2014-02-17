Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaBQUsL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 15:48:11 -0500
Received: from nm40.bullet.mail.ne1.yahoo.com ([98.138.229.33]:42423 "EHLO
	nm40.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751100AbaBQUsI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 15:48:08 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 332526.99317.bm@omp1012.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=xQJcRVRUB4p+g0cG1R25FElAQ9YDANutZVj6CdJUP8dcs2O7h1kAmyMvqz8AGgwk/Jvf6xX2YwOsibG5ZOgAbbMT0sgm3AsYCFvmLkZu2oaTJKCeDUWR1OIrOPTmZGQ3UaNcz70MJ6Ob7e18BuxjM355Ri8+oJLPtnIzyU/eNvw=;
X-YMail-OSG: wjjcfb4VM1mBCYGir0oQBrbk5F9ZIkjao_AOodM_.FH22WY
 FAVWRVmRIR4vcC8nR8WJtfCi49Wgjuzua61ZuvyP0Tv9unmYjy1geZ3zeWsf
 atqBiJQ.e8p9JCXN4W8oBn.DYzfCpuKbFUgvFTv1noOxen9DSc5fuQIcIZEn
 vuAf0HjhfeApEOHOCYI0nI1a3.vTPcQRf6DR8b48XkjKvhidUkNt_2VbcNUL
 ggfZPBeWhJpctSLjKHf748QXooqp.4YfacLfmFYGtZUBkFqXtbTbLLIXx4OH
 B_JwfhUbM1Tk37BL6OnauB9sCFyBiRRuLU8ksOgJzrZ6M7h6uBWxgWa31qbe
 pZ.mg3XAFyjadZMmlpi5RihONzqvRSaQtgEQWFCzO3ZiHFKDRSVRW4MU0s.H
 pDyXGK_qcyaDek3m8UzL1i6YkIAPcTgg4yNTDAXlQCyOPcQj6a6SMFVY7Evu
 4h6Kzme9.kxBt7ruMycSbUrSRyAojitm6BYDx8DdYmXpvex0GYnQ3NS8sDOb
 2pK2zysdRvlbgcWtS_toa1l4IA.vYAyzMJtT_
X-Rocket-MIMEInfo: 002.001,Pk9uIE1vbmRheSwgRmVicnVhcnkgMTcsIDIwMTQgNzoxNiBBTSwgSWFuIEFiYm90dCA8YWJib3R0aUBtZXYuY28udWs.IHdyb3RlOgoKPj5PbiAyMDE0LTAyLTE2IDA4OjQwLCBDaGFzZSBTb3V0aHdvb2Qgd3JvdGU6Cj4.IFRoaXMgcGF0Y2ggZm9yIGh3ZHJ2X2FwY2kwMzUgcmVtb3ZlcyBzb21lIHVubmVlZGVkIGJyYWNlcywgYW5kIG1vdmVzIHNvbWUKPj4gaW1wcm9wZXJseSBwbGFjZWQgYnJhY2VzIHRvIHRoZSBjb3JyZWN0IHBvc2l0aW9uLCBhcyBmb3VuZCBieSBjaGVja3BhdGNoLgo.PiBJdCBhbHNvIHIBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1392540006-25972-1-git-send-email-chase.southwood@yahoo.com> <53020B92.6060805@mev.co.uk>
Message-ID: <1392669907.92125.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Mon, 17 Feb 2014 12:45:07 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 1/4] Staging: comedi: addi-data: fix brace-related coding style issues in hwdrv_apci035.c
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <53020B92.6060805@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Monday, February 17, 2014 7:16 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-02-16 08:40, Chase Southwood wrote:
>> This patch for hwdrv_apci035 removes some unneeded braces, and moves some
>> improperly placed braces to the correct position, as found by checkpatch.
>> It also removes a commented out if-statement that I found whilst cleaning
>> braces that is identical to another un-commented if-statement directly
>> above it, so it is just added clutter and so we can delete it to clean up
>> further.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> So I decided to venture into addi-data today and found that most of the
>> files in there are very messy from a style standpoint.  This is the first
>> (of probably a few) patchsets to try and clean those files up a bit.  I
>> hope that this will be helpful!
>
>Quite a few have been cleaned up extensively by Hartley, but they needed 
>more extensive changes than clean-ups due to them trying to handle 
>things differently to the normal comedi way of doing things.

Oh, I see.  Makes perfect sense.  Well like I said, if cleaning them up a bit will help make reworking them any easier or seems like useful work, I'd be happy to continue making them a little easier on the eyes!

>>
>>   .../comedi/drivers/addi-data/hwdrv_apci035.c       | 49 ++++++++++------------
>>   1 file changed, 22 insertions(+), 27 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> index 1128c22..584a1d5 100644
>> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> @@ -177,11 +177,11 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>>       devpriv->tsk_Current = current;
>>       devpriv->b_TimerSelectMode = data[0];
>>       i_WatchdogNbr = data[1];
>> -    if (data[0] == 0) {
>> +    if (data[0] == 0)
>>           ui_Mode = 2;
>> -    } else {
>> +    else
>>           ui_Mode = 0;
>> -    }
>> +
>>   /* ui_Command = inl(devpriv->iobase+((i_WatchdogNbr-1)*32)+12); */
>>       ui_Command = 0;
>>   /* ui_Command = ui_Command & 0xFFFFF9FEUL; */
>> @@ -366,8 +366,7 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>>               devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>>       }
>>
>> -    if (data[0] == 0)    /* Stop The Watchdog */
>> -    {
>> +    if (data[0] == 0) {
>>           /* Stop The Watchdog */
>>           ui_Command = 0;
>>   /*
>> @@ -377,15 +376,15 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>>           outl(ui_Command,
>>               devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>>       }            /*   if (data[1]==0) */
>> -    if (data[0] == 3)    /* stop all Watchdogs */
>> -    {
>> +    if (data[0] == 3) {
>> +        /* stop all Watchdogs */
>>           ui_Command = 0;
>>           for (i_Count = 1; i_Count <= 4; i_Count++) {
>> -            if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
>> +            if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
>>                   ui_Command = 0x2UL;
>> -            } else {
>> +            else
>>                   ui_Command = 0x10UL;
>> -            }
>> +
>>               i_WatchdogNbr = i_Count;
>>               outl(ui_Command,
>>                   devpriv->iobase + ((i_WatchdogNbr - 1) * 32) +
>> @@ -393,30 +392,29 @@ static int i_APCI035_StartStopWriteTimerWatchdog(struct comedi_device *dev,
>>           }
>>
>>       }
>> -    if (data[0] == 4)    /* start all Watchdogs */
>> -    {
>> +    if (data[0] == 4) {
>> +        /* start all Watchdogs */
>>           ui_Command = 0;
>>           for (i_Count = 1; i_Count <= 4; i_Count++) {
>> -            if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
>> +            if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
>>                   ui_Command = 0x1UL;
>> -            } else {
>> +            else
>>                   ui_Command = 0x8UL;
>> -            }
>> +
>>               i_WatchdogNbr = i_Count;
>>               outl(ui_Command,
>>                   devpriv->iobase + ((i_WatchdogNbr - 1) * 32) +
>>                   0);
>>           }
>>       }
>> -    if (data[0] == 5)    /* trigger all Watchdogs */
>> -    {
>> +    if (data[0] == 5) {
>> +        /* trigger all Watchdogs */
>>           ui_Command = 0;
>>           for (i_Count = 1; i_Count <= 4; i_Count++) {
>> -            if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG) {
>> +            if (devpriv->b_TimerSelectMode == ADDIDATA_WATCHDOG)
>>                   ui_Command = 0x4UL;
>> -            } else {
>> +            else
>>                   ui_Command = 0x20UL;
>> -            }
>>
>>               i_WatchdogNbr = i_Count;
>>               outl(ui_Command,
>> @@ -488,11 +486,9 @@ static int i_APCI035_ReadTimerWatchdog(struct comedi_device *dev,
>>       /* Get the overflow status */
>>       /***************************/
>>       data[3] = ((ui_Status >> 0) & 1);
>> -    if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER) {
>> +    if (devpriv->b_TimerSelectMode == ADDIDATA_TIMER)
>>           data[4] = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 0);
>>
>> -    }            /*   if  (devpriv->b_TimerSelectMode==ADDIDATA_TIMER) */
>> -
>>       return insn->n;
>>   }
>>
>> @@ -655,8 +651,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
>>       ui_StatusRegister2 =
>>           inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 20);
>>
>> -    if ((((ui_StatusRegister1) & 0x8) == 0x8))    /* Test if warning relay interrupt */
>> -    {
>> +    /* Test if warning relay interrupt */
>> +    if ((((ui_StatusRegister1) & 0x8) == 0x8)) {
>>       /**********************************/
>>           /* Disable the temperature warning */
>>       /**********************************/
>> @@ -675,9 +671,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
>>       }            /* if (((ui_StatusRegister1 & 0x8) == 0x8)) */
>>
>>       else {
>> -        if ((ui_StatusRegister2 & 0x1) == 0x1) {
>> +        if ((ui_StatusRegister2 & 0x1) == 0x1)
>>               send_sig(SIGIO, devpriv->tsk_Current, 0);    /*  send signal to the sample */
>> -        }
>>       }            /* else if (((ui_StatusRegister1 & 0x8) == 0x8)) */
>>
>>       return;
>>
>
>Looks good.
>
>Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
>
>-- 
>-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
>

Thanks,
Chase

