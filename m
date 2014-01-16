Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544AbaAPRtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 12:49:32 -0500
Received: from nm42.bullet.mail.ne1.yahoo.com ([98.138.120.49]:28289 "EHLO
	nm42.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751047AbaAPRt3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 12:49:29 -0500
X-Yahoo-Newman-Property: ymail-4
X-Yahoo-Newman-Id: 470245.22070.bm@omp1033.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=neq+UZBAztsaaGENNsHb+VdsFjSo8ymqYao2uPnS7Cz+iWz8RDGUKV/JYxaMz/xao0OWCY0RwgW+IdaHunyzWazpurh37XJDwPBS2T6OPmvfxF9xwQwFt9Wbb/7GwMblS/KYBYm8ViLwbBaMcsZ+L+45AiesJ2MIdwKUEYzyTjk=;
X-YMail-OSG: hBbSoO0VM1m6G3Q5cI0u3uUi0fbk0VS0Il1fBLqYBDg4YWB
 4XDkmsc1kjAOrC7JpqDPKfpAQDnF4Dqg4rO71b.BUxNr8czevrSV4VwhsAcl
 kVV.tdg4VVVZhDTuEWqEBpGKJuDXSEtVblxstF8SaKUJxiPG10jezCvIhNhE
 KqTcNQl39i0pCIwh.GwwJ54RerBYBUPIItk2AtObhqIvxpcEpAnzUKNghaiT
 ygy0fIacaIzUixSqlHHzhuEYBJZRc8xsU5lYhFhg_5gSAKItxVx_o.hThymI
 xIJNgKSM5mD8Gnp7wE2phTlvgZ4S222L408TxbMeOwVflsJMunpCAkIpBXUf
 2qhHj.JcQbST5f34L1XurvEnU13GrpShvL_jqf.pA7Tr2yZxqxDGslpNtzdx
 F32d8DzMgU3hdw3AT51GZyIWFY0ygDe1Ic0QyXuP_67UXiHVVeK_m4RRYc_E
 ZTtT3KZ4dP5F66OgLPEAZcJvZeItcsdnXAyPHk_8MmGA.mQ47bTLE9wfVq3i
 E4OquwEOgP6yGxKMYS71qSS8POrVoV1lNeTYMyFPFbGYPJBGEbFrJ4njKb4Y
 7JUlv_bwemz22YSNEBT7vVGkj9RgH59yd8XNav3RD8gCNlbjSx0_az985gW9
 nQ.S1FKrKErE2E4M-
X-Rocket-MIMEInfo: 002.001,Pk9uIFRodXJzZGF5LCBKYW51YXJ5IDE2LCAyMDE0IDU6MzEgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKCj5PbiAyMDE0LTAxLTE1IDE5OjIyLCBDaGFzZSBTb3V0aHdvb2Qgd3JvdGU6Cj4.IFRoaXMgcGF0Y2ggZm9yIG5pX21pb19jb21tb24uYyBjaGFuZ2VzIG91dCBhIHdoaWxlIGxvb3AgZm9yIGEgdGltZW91dCwKPj4gd2hpY2ggaXMgcHJlZmVycmVkLgo.Pgo.PiBTaWduZWQtb2ZmLWJ5OiBDaGFzZSBTb3V0aHdvb2QgPGNoYXNlLnNvdXRod29vZEB5YWhvby5jb20.Cj4.IC0BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.173.622
References: <1389669228-15090-1-git-send-email-chase.southwood@yahoo.com> <1389813752-3009-1-git-send-email-chase.southwood@yahoo.com> <52D7C2E8.9060204@mev.co.uk>
Message-ID: <1389894391.35761.YahooMailNeo@web164002.mail.gq1.yahoo.com>
Date: Thu, 16 Jan 2014 09:46:31 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH v7] Staging: comedi: convert while loop to timeout in ni_mio_common.c
To: Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <52D7C2E8.9060204@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thursday, January 16, 2014 5:31 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>On 2014-01-15 19:22, Chase Southwood wrote:
>> This patch for ni_mio_common.c changes out a while loop for a timeout,
>> which is preferred.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>>
>> Hartley,
>> I sincerely apologize for the obvious mistake, I thought I had built it
>> but clearly I made a mistake somewhere, as your observation is exactly
>> correct.  It is now fixed.
>>
>> Thanks,
>> Chase Southwood
>>
>> 2: Changed from simple clean-up to swapping a timeout in for a while loop.
>>
>> 3: Removed extra counter variable, and added error checking.
>>
>> 4: No longer using counter variable, using jiffies instead.
>>
>> 5: udelay for 10u, instead of 1u.
>>
>> 6: Scrap udelay entirely, in favor of cpu_relax. Include asm/processor.h
>> in order to use cpu_relax.
>>
>> 7: Fix typo (msec vs msecs).
>>
>>   drivers/staging/comedi/drivers/ni_mio_common.c | 12 +++++++++++-
>>   1 file changed, 11 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c >b/drivers/staging/comedi/drivers/ni_mio_common.c
>> index 457b884..ab7a74c 100644
>> --- a/drivers/staging/comedi/drivers/ni_mio_common.c
>> +++ b/drivers/staging/comedi/drivers/ni_mio_common.c
>> @@ -55,6 +55,7 @@
>>   #include <linux/interrupt.h>
>>   #include <linux/sched.h>
>>   #include <linux/delay.h>
>> +#include <asm/processor.h>
>>   #include "8255.h"
>>   #include "mite.h"
>>   #include "comedi_fc.h"
>> @@ -687,12 +688,21 @@ static void ni_clear_ai_fifo(struct comedi_device *dev)
>>   {
>>       const struct ni_board_struct *board = comedi_board(dev);
>>       struct ni_private *devpriv = dev->private;
>> +    unsigned long timeout;
>>
>>       if (board->reg_type == ni_reg_6143) {
>>           /*  Flush the 6143 data FIFO */
>>           ni_writel(0x10, AIFIFO_Control_6143);    /*  Flush fifo */
>>           ni_writel(0x00, AIFIFO_Control_6143);    /*  Flush fifo */
>> -        while (ni_readl(AIFIFO_Status_6143) & 0x10) ;    /*  Wait for complete */
>> +        /*  Wait for complete */
>> +        timeout = jiffies + msecs_to_jiffies(500);
>> +        while (ni_readl(AIFIFO_Status_6143) & 0x10) {
>> +            if (time_after(jiffies, timeout)) {
>> +                comedi_error(dev, "FIFO flush timeout.");
>> +                break;
>> +            }
>> +            cpu_relax();
>> +        }
>>       } else {
>>           devpriv->stc_writew(dev, 1, ADC_FIFO_Clear);
>>           if (board->reg_type == ni_reg_625x) {
>>

>Sorry this is your worst nightmare, Chase.  Your patch is great and has 
>been modified in all the ways various people have suggested, but I don't 
>think it is suitable.
>
>After examining the code, it turns out ni_clear_ai_fifo() is sometimes 
>called from an interrupt service routine and I don't think you can wait 
>for jiffies to change in that case.  I think we need to go back to your 
>PATCH v2 and fix up the checkpatch.pl warning that Greg mentioned.
>
>Sorry about that.
>
>-- 
>-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

It's absolutely no problem.  I'll get v2 cleaned up and sent out right away!

Thanks,
Chase Southwood
