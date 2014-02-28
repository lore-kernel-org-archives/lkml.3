Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaB1IEC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 03:04:02 -0500
Received: from nm18-vm3.bullet.mail.gq1.yahoo.com ([98.136.217.218]:32582 "EHLO
	nm18-vm3.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbaB1IEA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 03:04:00 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 950463.60023.bm@omp1038.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rgQmd2LPDly8NMB4mU8PHmF7hS9nrmuTASqpj2jr3OQcQkb+dOUBnjqxy+Sxc96g/RDjP0iL/tl6P1yyY8l8MXRNaqpyqvfy2S9i42hPvXQcLX6hr8tVMaQfXmMdDK7QjOFQlkwttt2zPtDgUAVc8igiqxg/hByQTWvJneEXHeE=;
X-YMail-OSG: oadB7QcVM1kzoni8ecsW9RYC2fpd6e_YJ8OFh.FIuDMt_PT
 _8gii0xdKT7thtEFTCLN0fhSUcgpJkWPHDxDBhlrzr3IYic73x6oiCXtMk8S
 DclS9iTq0FWTVzHNLlK4Kki1Fn_Y2XRP4oOV6Wus7X.SBNMTILmtq48nDr.o
 qRWR5TWjmYYGBiNqra5wu6LpMNkDUA6pj4GaHxNnooz9sgY69hJyYS0ubaL4
 wn0bDuvrwxqIDD1b3vtcaGhl.tXNOtqNLDyDEX1.SYdoFllnirAXA8DGlU6P
 _bU6VyZ0WVXzP490QcN_T0sFKAvGodQink0kQW1tMDjwgdP4OajjRIvX7n8E
 aM.ZHzZe_Rh5qrwf3xrzgpZ6O43bn_RVvqO1aAFiipbFVvn5y3WtEumzYi94
 w05jErqn6rF2nSrRtaDWfLE9ElXAe9C6KV31HaQTjKEVudDC0NdcqcyDegSv
 zmwRTu3yAmmFcyAPUjWs6p3jZnjDBkIAACmEP7c9fZSQ1AbY_2m5uPErk2Hq
 xL6OOdXH4nhlAWjcZIaVXDgHG2fsOPTY-
X-Rocket-MIMEInfo: 002.001,Pk9uIEZyaWRheSwgRmVicnVhcnkgMjgsIDIwMTQgMTo1NyBBTSwgRGFuIENhcnBlbnRlciA8ZGFuLmNhcnBlbnRlckBvcmFjbGUuY29tPiB3cm90ZToKCj4.T24gRnJpLCBGZWIgMjgsIDIwMTQgYXQgMTA6NTI6MzJBTSArMDMwMCwgRGFuIENhcnBlbnRlciB3cm90ZToKPj4.IE9uIEZyaSwgRmViIDI4LCAyMDE0IGF0IDAxOjMxOjIwQU0gLTA2MDAsIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj4gPiBod2Rydl9hcGNpMTU2NC5jIGhhZCBudW1lcm91cyBsaW5lcyBvdmVyIHRoZSBjb2x1bW4gbGltaXQuwqAgVGgBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572680-9521-1-git-send-email-chase.southwood@yahoo.com> <20140228075232.GH26776@mwanda> <20140228075650.GI26776@mwanda>
Message-ID: <1393574639.1751.YahooMailNeo@web164003.mail.gq1.yahoo.com>
Date: Fri, 28 Feb 2014 00:03:59 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 1/2] Staging: comedi: addi-data: fix lines that are over 80 characters
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Chase Southwood <chase.southwoo@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>
In-Reply-To: <20140228075650.GI26776@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Friday, February 28, 2014 1:57 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:

>>On Fri, Feb 28, 2014 at 10:52:32AM +0300, Dan Carpenter wrote:
>>> On Fri, Feb 28, 2014 at 01:31:20AM -0600, Chase Southwood wrote:
>> > hwdrv_apci1564.c had numerous lines over the column limit.  This patch
>> > splits all such lines to bring them in compliance with coding style.
>> > 
>> > Signed-off-by: Chase Southwood <chase.southwoo@yahoo.com>
>> > ---
>> >  .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 50 ++++++++++++++++------
>> >  1 file changed, 36 insertions(+), 14 deletions(-)
>> > 
>> > diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
>> > index 2b47fa1..77030c5 100644
>> > --- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
>> > +++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c
>> > @@ -324,11 +324,15 @@ static int i_APCI1564_ConfigTimerCounterWatchdog(struct comedi_device *dev,
>> >              inl(devpriv->i_IobaseAmcc + APCI1564_TIMER +
>> >              APCI1564_TCW_PROG);
>> >          ul_Command1 = ul_Command1 & 0xFFFFF9FEUL;
>> > -        outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER + APCI1564_TCW_PROG);    /* Stop The Timer */
>> > +        /* Stop The Timer */
>> > +        outl(ul_Command1, devpriv->i_IobaseAmcc + APCI1564_TIMER +
>> > +            APCI1564_TCW_PROG);
>> 
>> Just make a helper function so that you can call it like this:
>> 
>> static void outl_1564_timer(struct addi_private *devpriv, unsigned int cmd,
>>                 unsigned int reg)
>> {
>>     outl(cmd, devpriv->i_IobaseAmcc + APCI1564_TIMER, reg);
>                                                        ^^^
>Should be "devpriv->i_IobaseAmcc + APCI1564_TIMER + reg" obviously.
>
>
>regards,
>dan carpenter

You got it, I'll do it this way and resend.

Thanks,
Chase
