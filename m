Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440AbaCGIbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 03:31:40 -0500
Received: from nm27-vm8.bullet.mail.gq1.yahoo.com ([98.136.216.151]:23142 "EHLO
	nm27-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834AbaCGIbi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 03:31:38 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 115718.39872.bm@omp1079.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=VT24xtFWMiBxBoCGdukgA0aWxK6XpskaaMCgyX23bedYxFeX8OcMF5ZQtbBYuzY7yawSIQgSGMll9cFQEdvDD4DWOnstYk9o/HYyE0pDJwnXbv5lrlozWC+Z0dr2mG+F/OlxOGlu1fA/eAY3Su9PZzqmARCkt0oC8WKCH530Yv0=;
X-YMail-OSG: UHKXhzAVM1lSO2PHSP22OFMFHNINsggGiIdUW7FST7zPL8P
 X84ArxxPlSyoJCz4IFNxmJi3hOl7oRWZUqa61r9QXF_p9ehMUG6I26AYffXR
 KngbpdwyT9_FJcxR.amB8dFVBHvi_6JFfy_l0Nwa7z1mikdUsZkGMwpzlckA
 dKlw93uk6CIC3pyUD_ODa27bGt65H_S94YE9DmdccM64i4OFePVvsovMA1lW
 9PALqXbCzNcnKCFHiHjdLER592UeoVrMhFeVr5uW4NgxyI942tjO9BtPQGvV
 vS7xB7nBcCxDYxbrVSGXACA.m_NieR1sp6_36Jtoq7FlYc1K7n6ZkkYzPb8Q
 qYxwjywK_FLErNg4LpXAlL2BF6aoAU3ADDFzH_8DRShqlzN8f8l.1grSszg6
 BCQsJ3TbsZxYiJfjseEsi2l5leMXsKDajKj2NToO1fSDD05FFNP2ky2DdqsB
 JZkDECNyVlxLFCGW8g0Xj6ZgkengvpxXBXPvHJzupuMMUhBXK_NiyjfC_Ud4
 IG4rSxApi1JH3rO0rNMZqTkxK8kO.m2Q-
X-Rocket-MIMEInfo: 002.001,Pk9uIFRodXJzZGF5LCBNYXJjaCA2LCAyMDE0IDExOjU5IEFNLCBIYXJ0bGV5IFN3ZWV0ZW4gPEhhcnRsZXlTQHZpc2lvbmVuZ3JhdmVycy5jb20.IHdyb3RlOgoKPj5PbiBUaHVyc2RheSwgTWFyY2ggMDYsIDIwMTQgMTI6MjYgQU0sIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj4KPj5UaGlzIHBhdGNoIGZvciBod2Rydl9hcGNpMTU2NC5jIGZpeGVzIHRoZSByZWdpc3RlciBtYXAgZGVmaW5lcyBmb3IgdGhlCj4.ZGlnaXRhbCBpbnB1dCByZWdpc3RlcnMgc3VjaCB0aGF0IHRoZXkgYXJlIGFsbCB0aGUgcmVhbCABMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1394090691-7850-1-git-send-email-chase.southwood@yahoo.com> <1394090783-8030-1-git-send-email-chase.southwood@yahoo.com> <DC148C5AA1CEBA4E87973D432B1C2D8825DA44FA@P3PWEX4MB008.ex4.secureserver.net>
Message-ID: <1394181097.66992.YahooMailNeo@web164005.mail.gq1.yahoo.com>
Date: Fri, 7 Mar 2014 00:31:37 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH 5/5] Staging: comedi: addi-data: tidy up counter register map defines in hwdrv_apci1564.c
To: Hartley Sweeten <HartleyS@visionengravers.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825DA44FA@P3PWEX4MB008.ex4.secureserver.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Thursday, March 6, 2014 11:59 AM, Hartley Sweeten <HartleyS@visionengravers.com> wrote:

>>On Thursday, March 06, 2014 12:26 AM, Chase Southwood wrote:
>>
>>This patch for hwdrv_apci1564.c fixes the register map defines for the
>>digital input registers such that they are all the real offsets to each
>>register, rather than a mix of real offsets and adders to those offsets.
>>
>>Signed-off-by: Chase Southwood <chase.southwood@yahoo.com>
>>---
>> .../comedi/drivers/addi-data/hwdrv_apci1564.c      | 101 +++++++++------------
>> 1 file changed, 44 insertions(+), 57 deletions(-)>
>
>This one is incomplete and breaks the build.
>
> CC [M]  drivers/staging/comedi/drivers/addi_apci_1564.o
>In file included from drivers/staging/comedi/drivers/addi_apci_1564.c:11:0:
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: In function >'i_APCI1564_ConfigTimerCounterWatchdog':
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:352:4: error: 'APCI1564_TCW_PROG' >undeclared (first use in this function)
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:352:4: note: each undeclared identifier is >reported only once for each function it appears in
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:359:4: error: 'APCI1564_TCW_RELOAD_VALUE' >undeclared (first use in this function)
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: In function >'i_APCI1564_StartStopWriteTimerCounterWatchdog':
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:463:19: error: 'APCI1564_TCW_PROG' >undeclared (first use in this function)
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c: In function >'i_APCI1564_ReadTimerCounterWatchdog':
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:526:4: error: >'APCI1564_TCW_SYNC_ENABLEDISABLE' undeclared (first use in this function)
>drivers/staging/comedi/drivers/addi-data/hwdrv_apci1564.c:529:19: error: 'APCI1564_TCW_TRIG_STATUS' >undeclared (first use in this function)
>make[4]: *** [drivers/staging/comedi/drivers/addi_apci_1564.o] Error 1
>make[3]: *** [drivers/staging/comedi/drivers] Error 2
>make[2]: *** [drivers/staging/comedi] Error 2
>make[1]: *** [drivers/staging] Error 2
>make: *** [drivers] Error 2
>
>Be sure to do a build after each patch to make sure it works.

Hartley,
I'm sorry for this, it appears that this whole patch series was sloppy
and quite untested by myself.  I have made up a fixed patchset and have
tested everything this time around, I trust that you should have a better
time reviewing this one.  I will not let this happen again in the future.

Thanks,
Chase

>
>Regards,
>Hartley

