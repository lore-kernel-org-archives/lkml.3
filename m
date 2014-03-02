Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaCBENg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 23:13:36 -0500
Received: from nm29-vm5.bullet.mail.gq1.yahoo.com ([98.136.216.180]:25500 "EHLO
	nm29-vm5.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751198AbaCBENf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 23:13:35 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 879710.9815.bm@omp1013.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=RUIbzAz38NX+H5bGoLGDykpacStkfPXCl16h+7zbBUfmR+myzapuhsLSh2yQ4ICwezkFoePPFTZFoWyq2CDrdbf70oXUAKKB1RNntq5JwFwBZihNMztnPRWvW3w3Jbfv7ZekuGaEvq1IQYnaB8arFBU2RQZrgoAh+z5cPjA4uRs=;
X-YMail-OSG: W336HycVM1nkeLzDpCs4usMtLax3MA9CgmqJ4D.ThJm5TvB
 K0MSPN12gqdeOoozsfMXZyvMGeSORKKtCAaLFp2BHblJ9wbUDMZwuX9XAP3u
 gD1R6JKse3bi8.wpSvlKikvhpcQjJm.3O6xsOVXeEmyH22SY3fpmCjR_5wde
 t1X5iugV7InYNALu2hGJCllwRQYGQtson7eM5SgF2U3AJdDwAd5cjxDPPeXQ
 ey0r7dDA0QUdulXgs8J6ATDJsKXRkhAoU_NX77V4jwqH6MiS1EIe_.Yf6vVA
 nCBtlcR2_A6K6uiWL8SPWkCwndRN3mRfeXY33xj20W9hwAm_lblKzCtxBxbL
 LNW8L2lsdY3Z00lb6I5PMvxqQuQxn5DGqccvdNeUT6P0LNg21X3QiHOXrH.W
 zoipmqNnZcLvmjvDhVsmDqe0zmKZlGT_pSWKoW6Zp8acZ5VEHgySkF..N9Xu
 RO6naiF3oean5klPSJ03siuJ8YSctpdOgmh.0YItFDzRbKoUq2IgasqmSv1H
 1K0EclM7VzoInrpbiVGGfgf0l7g--
X-Rocket-MIMEInfo: 002.001,Pk9uIEZyaWRheSwgRmVicnVhcnkgMjgsIDIwMTQgMTE6NDkgUE0sIENoYXNlIFNvdXRod29vZCA8Y2hhc2Uuc291dGh3b29kQHlhaG9vLmNvbT4gd3JvdGU6Cgo.Pk9uIEZyaWRheSwgRmVicnVhcnkgMjgsIDIwMTQgMTE6MjYgQU0sIElhbiBBYmJvdHQgPGFiYm90dGlAbWV2LmNvLnVrPiB3cm90ZToKPj4.T24gMjAxNC0wMi0yOCAwNzozNSwgQ2hhc2UgU291dGh3b29kIHdyb3RlOgoKW3NuaXBdCgo.PkluIHRoZSBjYXNlIG9mIHM2MjZfc2VuZF9kYWMoKSwgaXQgZG9lc24ndCBzZWVtIHRvIGJlIHVzZWQgaW4BMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <5310C4CB.2060201@mev.co.uk> <1393652927.45628.YahooMailNeo@web164006.mail.gq1.yahoo.com>
Message-ID: <1393733614.99805.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Sat, 1 Mar 2014 20:13:34 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH] Staging: comedi: add timeouts to while loops in s626.c
To: Chase Southwood <chase.southwood@yahoo.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: Ian Abbott <ian.abbott@mev.co.uk>,
        "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1393652927.45628.YahooMailNeo@web164006.mail.gq1.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Friday, February 28, 2014 11:49 PM, Chase Southwood <chase.southwood@yahoo.com> wrote:

>>On Friday, February 28, 2014 11:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>>>On 2014-02-28 07:35, Chase Southwood wrote:

[snip]

>>In the case of s626_send_dac(), it doesn't seem to be used in any 
>>critical sections, so it could make use of Hartley's comedi_timeout().
>>
>>Some of the timeout errors could be propagated, especially for 
>>s626_send_dac() which is only reachable from very few paths.
>
>
>Awesome, I'll swap all of my timeouts out for comedi_timeout() in s626_send_dac().

Actually, after taking another look at this, I don't think that using comedi_timeout()
here is going to work, actually.
The context from which s626_send_dac() is called allows sleep all right, but readl() isn't
a comedi function and therefore it doesn't behave (in parameters or return values) as
the callback function parameter to comedi_timeout() requires.  So unless I'm missing
something particularly large here, I believe we'll have to do the timeouts here manually
as well.  Am I correct here, and if so, would you like the iteration based timeouts here
as well, or a sleep-based timeout similar to that employed by comedi_timeout()?


Thanks,
Chase
