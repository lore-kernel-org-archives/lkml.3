Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751447AbaB1Jxv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:53:51 -0500
Received: from nm12-vm2.bullet.mail.gq1.yahoo.com ([98.136.218.189]:48645 "EHLO
	nm12-vm2.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751077AbaB1Jxr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:53:47 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 321190.27806.bm@omp1013.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=FzNYE7LI22ALD5SHzo+Kp51ed4AdFXEuM7cz8nrpnMa13OStg8kjfyZtjxdVXBsLMuS1ZREcQ6EQPg2LlBKhg2Pm6waJYIYVBDzwAdWTQbIjrfgA8CSOBz4WHes6idLio/sUiRfhX/x5iue3dKJswTQpKD0fJSeGPPQo/N5f168=;
X-YMail-OSG: bEKjkYQVM1k8zQgKhd8AZrrR3SlEFaQp.I4.Se6Gv7UwXWZ
 eIfWi1jLEyu77tgonx8H.JE4SNNIl40Qe9la5gZ_v.NCyHhm2hWJ.sIcrzvW
 3xLIDZJiWRR._e6LKG3Z0PhwlpuSvZuZN3b8fzMaMOgPwkiOOWp89xA4ZFLQ
 gb_uBYGvp2YBUjTQ4d9yiPOfcUIiPb6OgWwUHmHNCPJB2XCg62nCX757yHJw
 e_OE4mC50bD8mMpEV4DC.Ff.NmFxqsBqb_sM809V8f6eZbdA1OwkiP0YRrF4
 WKeit7RP0xtgyxv1W5L2hcOsBNciyXPXItSa2VBWGNJSeIVpm2ou4SdeMsB6
 TpRlUl0WN4h6MMXHkbjoMO49Bn25vjb5mokFG.G3wiq7xjXoRXn9JWvJJbVG
 UweFPs_gixJ8mEHj2VT26wdWgDybtOIPwCGH58dU2ITrEipZMrsxgbCDi_1_
 oqnGNn7TEa5ZCSrLMUBhyVV6VFbbBl_fXcNDEMkrxNOWjPWB.EdwfKs9z3hu
 N123_3AWcgdFnGzAV8u3gM71kPYyPWUgO
X-Rocket-MIMEInfo: 002.001,Pk9uIEZyaWRheSwgRmVicnVhcnkgMjgsIDIwMTQgMzo0MiBBTSwgRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPiB3cm90ZToKCj4.T24gRnJpLCBGZWIgMjgsIDIwMTQgYXQgMDM6MTU6NDVBTSAtMDYwMCwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgo.PiBUaGlzIHBhdGNoIGludHJvZHVjZXMgYSBzaW1wbGUgaGVscGVyIGZ1bmN0aW9uLCBvdXRsXzE1NjRfdGltZXIoKSwgdG8KPj4gYWxsb3cgc2V2ZXJhbCBsaW5lcyB3aGljaCB2aW9sYXRlIHRoZSBjaGFyYWN0ZXIgbGltaXQgdG8gYmUBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com> <1393578945-20488-1-git-send-email-chase.southwood@yahoo.com> <20140228094215.GJ26776@mwanda>
Message-ID: <1393581227.57507.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Date: Fri, 28 Feb 2014 01:53:47 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 1/2 v2] Staging: comedi: fix lines that are over 80 characters
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20140228094215.GJ26776@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Friday, February 28, 2014 3:42 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

>>On Fri, Feb 28, 2014 at 03:15:45AM -0600, Chase Southwood wrote:
>> This patch introduces a simple helper function, outl_1564_timer(), to
>> allow several lines which violate the character limit to be shortened.
>> A handful of other lines that are too long are appropriately split as
>> well.
>> 
>> Cc: Dan Carpenter <dan.carpenter@oracle.com>
>> Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>> ---
>> 2: introduced outl_1564_timer() at the suggestion of Dan.
>>  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 83 +++++++++++++---------
>>  1 file changed, 49 insertions(+), 34 deletions(-)
>> 
>> diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
>> index 2b47fa1..d958d3c 100644
>> --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
>> +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
>> @@ -99,6 +99,9 @@ This program is distributed in the hope that it will be useful, but WITHOUT ANY
>>  #define APCI1564_TCW_WARN_TIMEVAL            24
>>  #define APCI1564_TCW_WARN_TIMEBASE            28
>>  
>> +/* Helper functions */
>
>Obvious comment is too obvious.
>
>> +static void outl_1564_timer(struct addi_private *, unsigned int, unsigned int);
>> +
>
>Avoid forward declarations.  Put the function itself here.
>
>Do a function for APCI1564_DIGITAL_IP as well.
>
>outl_1564_digital_ip()
>inl_1564_digital_ip()
>
>To be honest, I'm not sure how much the 1564 adds to the name.  The
>names should match of course.
>
>I wonder if this line is buggy?:
>outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP_INTERRUPT_MODE1); /* Disable the >and/or interrupt */
>Should it be?
>outl(0x0, devpriv->i_IobaseAmcc + APCI1564_DIGITAL_IP + >APCI1564_DIGITAL_IP_INTERRUPT_MODE1);
>
>You would need to read the specs to be sure.
>
>Anyway, take some more time with this and play with different ways to
>clean it up.
>
>regards,
>
>dan carpenter

Hey Dan!

Thanks a lot, I really appreciate all of the really good feedback.  It's getting late now, but tomorrow I'll work on tidying everything up based on all of these comments and double check that hardware spec as well.

Thanks,
Chase
