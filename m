Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbaBXQCE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 11:02:04 -0500
Received: from nm18-vm2.bullet.mail.gq1.yahoo.com ([98.136.217.217]:37808 "EHLO
	nm18-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752578AbaBXQA1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 11:00:27 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 886831.52108.bm@omp1018.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=W9pE+Hd9QN7t6kn60ygk9rjNkmMvsJ90cbKKCum2AXQAg9lN3lmXNfXiAdMyGj8W1xvnwyJTzTvnSlgyavqAXfqKoWlOArNOY25VSCZBO2eLpzL9DlR6P0XogCoFu6Ur3hVFwOe+eSPXQKS/5KfvsWlxfPoz00E7H6yp9tBY28E=;
X-YMail-OSG: O1Ugo34VM1mPMIV2zuSv2AthPtdlhLJmA_TC1lQKAOlongt
 x6vjzzJgj9lHIzmLGipPqq5Qc1rsvK726o2L9.MMrGjWQA0Ld5qSuRpiDlhP
 5g2lMExXhxDCYLC4fTYO0wVdLdmxtnUjAQcoK45cs0kjKuVcOWSXXhmOw2Zj
 F.K5.482NoAFCrBAjooSeCZn.YG6yb1wFkFvj7kwyeT9JYQiNLb52b.BpBpH
 LRhBdRGNLv_cWKV4VEjYLl2BEIVhJbccBQ2fTpb2sgXKq6VoL8GWTUGZQzcu
 tD2pWLTFeR_uoeXFgHhQT5oL5aJkQ0VAAauGlTW8lYnklpTfr.Y.C3S1pJUE
 4bShUeu82.dn6uwIS0apUAv3b51Z.AkTT4ZvTScPlin8A3T0PyD1SKFmmVEG
 A.HSZtb0XQS_pL1nc9Semb_xR6FGCSLrH4f7sX6fWH7mAvrblMFPvQb6rXAt
 T0U8Rpr_fL9QxpYplEGZwxba6Gj.QzCRqXUm0ir3z7oPISjodLA0_a6ax8Ry
 0eDf2e8f6xuDAgFZEBjS_
X-Rocket-MIMEInfo: 002.001,Pk9uIE1vbmRheSwgRmVicnVhcnkgMjQsIDIwMTQgODoxMyBBTSwgSWFuIEFiYm90dCA8YWJib3R0aUBtZXYuY28udWs.IHdyb3RlOgoKPj5PbiAyMDE0LTAyLTIyIDAzOjIxLCBDaGFzZSBTb3V0aHdvb2Qgd3JvdGU6Cj4.IFRoZXJlIHdlcmUgc29tZSBjb25kaXRpb25hbCBibG9ja3MgdGhhdCBoYWQgYW4gdW5uZWNjZXNhcnkgbGV2ZWwgb2YKPj4gaW5kZW50YXRpb24gaW4gdGhlbS7CoCBXZSBjYW4gcmVtb3ZlIHRoaXMgdG8gaW1wcm92ZSBjb2RlIGNsYXJpdHkuCj4.Cj4.IFNpZ25lZC1vZmYtYnk6IENoYXMBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393039229-7184-1-git-send-email-chase.southwood@yahoo.com> <1393039279-7229-1-git-send-email-chase.southwood@yahoo.com> <530B539B.8050201@mev.co.uk>
Message-ID: <1393257626.16647.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Mon, 24 Feb 2014 08:00:26 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 2/3] Staging: comedi: addi-data: cleanup conditional blocks in hwdrv_apci035.c
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <530B539B.8050201@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Monday, February 24, 2014 8:13 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-02-22 03:21, Chase Southwood wrote:
>> There were some conditional blocks that had an unneccesary level of
>> indentation in them.  We can remove this to improve code clarity.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>>   .../comedi/drivers/addi-data/hwdrv_apci035.c       | 31 ++++++++++------------
>>   1 file changed, 14 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> index 7c40535..34e5321 100644
>> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci035.c
>> @@ -207,23 +207,22 @@ static int i_APCI035_ConfigTimerWatchdog(struct comedi_device *dev,
>>           ui_Command =
>>               (ui_Command & 0xFFF719E2UL) | ui_Mode << 13UL | 0x10UL;
>>
>> -    } else {
>> -        if (data[0] == ADDIDATA_WATCHDOG) {
>> +    } else if (data[0] == ADDIDATA_WATCHDOG) {
>>
>> -            /* Set the mode :             */
>> -            /* - Disable the hardware     */
>> -            /* - Disable the counter mode */
>> -            /* - Disable the warning      */
>> -            /* - Disable the reset        */
>> -            /* - Disable the timer mode   */
>> +        /* Set the mode :             */
>> +        /* - Disable the hardware     */
>> +        /* - Disable the counter mode */
>> +        /* - Disable the warning      */
>> +        /* - Disable the reset        */
>> +        /* - Disable the timer mode   */
>>
>> -            ui_Command = ui_Command & 0xFFF819E2UL;
>> +        ui_Command = ui_Command & 0xFFF819E2UL;
>>
>> -        } else {
>> -            dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
>> -            return -EINVAL;
>> -        }
>> +    } else {
>> +        dev_err(dev->class_dev, "The parameter for Timer/watchdog selection is in error\n");
>> +        return -EINVAL;
>>       }
>> +
>>       outl(ui_Command, devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>>       ui_Command = 0;
>>       ui_Command = inl(devpriv->iobase + ((i_WatchdogNbr - 1) * 32) + 12);
>> @@ -628,10 +627,8 @@ static void v_APCI035_Interrupt(int irq, void *d)
>>           send_sig(SIGIO, devpriv->tsk_Current, 0);    /*  send signal to the sample */
>>       }
>>
>> -    else {
>> -        if ((ui_StatusRegister2 & 0x1) == 0x1)
>> -            send_sig(SIGIO, devpriv->tsk_Current, 0);    /*  send signal to the sample */
>> -    }
>> +    else if ((ui_StatusRegister2 & 0x1) == 0x1)
>> +        send_sig(SIGIO, devpriv->tsk_Current, 0);    /*  send signal to the sample */>
>
>The usual style there is to put the "else" or the "else if" on the same 
>line as the preceding closing brace.
>
>Also, if any branch in the if, else if, ..., else chain uses braces, 
>they all should (see the bit that says "This does not apply if only one 
>branch of a conditional statement is a single statement; in the latter 
>case use braces in both branches:" in the CodingStyle).
>

Ah geez, don't know how that else if placement slipped through the cracks...my mistake.  I've got a revision coming straight away that moves it to the proper place and puts back my overzealous brace deletion.

>
>>
>>       return;>>
>>   }
>>
>
>
>-- 
>-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
>

Thanks,
Chase
