Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbaCDEG0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:06:26 -0500
Received: from nm3-vm8.bullet.mail.gq1.yahoo.com ([98.136.218.151]:20269 "EHLO
	nm3-vm8.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755999AbaCDEGY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:06:24 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 138692.34272.bm@omp1024.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=PlYlnf6v7qi82Vu/0g7KwnCWt+iLPC1PtlQO8EDTU/yYqmahDN+KyIJkW4S+E6re6hAcUwYD9RzJqOB72eBy6dlz+kI96yGMa0o35D+JmRIgYT6fyyVmD0CDQvtj/cyCFYq/TZCgDrCZLPrz4VvrwOMxbLjAc6UDoaC1renfQXo=;
X-YMail-OSG: gyvxoMIVM1kwETOK9ijPm9aLvZsdEppOQbO6YcJqmbq24qT
 jv0DQiCgtnFbUOnawYXBn4Bxrr8DdvZ2j_Urd9P6ZkCX1uE5EEVY5pyul4oB
 nvqAauctLkigiAxqLCsz6nYJpE.hTRXqdKiBpbmppPt3M3QHzsJ5Tn9JmWrn
 gkZKseg02h.8gB8_Jy67cM6pUWQTTwsrdnArjslAh5hM0wZaYpGyWJJ3vcDI
 ltNI7LPDHaLsxfF.dvuT.SUr_pCDeQUnZY6AILSu2ESlUEEvbTHYPphZPXMN
 AQLjYvH3avRNUK739Kq4DMY6.dZZzeT5Mx2fEmvRBE776wd1sdcG4_ChKsSS
 WJQz58yDdeNlgSLLfxg0aJrMhO.OF0zY6q6wmwJp.SoAg_jjXvzQSbevUQhC
 F9t2SDj1POCmHNgNrduZ6NMAEdC9SZbmiKF6N1UXT9FwdZN0hBu5GCGnAT43
 lbanHyNww1DZco2V4B0.u2PUDz6po19ftk9x1wDk7Nfy_mJ.LOQ4jcQnXepg
 OLTRULSJnVja1snzW6AXZ
X-Rocket-MIMEInfo: 002.001,Pk9uIE1vbmRheSwgTWFyY2ggMywgMjAxNCA4OjEzIEFNLCBJYW4gQWJib3R0IDxhYmJvdHRpQG1ldi5jby51az4gd3JvdGU6Cgo.Pk9uIDIwMTQtMDMtMDIgMDQ6MTMsIENoYXNlIFNvdXRod29vZCB3cm90ZToKPj4.T24gRnJpZGF5LCBGZWJydWFyeSAyOCwgMjAxNCAxMTo0OSBQTSwgQ2hhc2UgU291dGh3b29kIDxjaGFzZS5zb3V0aHdvb2RAeWFob28uY29tPiB3cm90ZToKPj4.PiBPbiBGcmlkYXksIEZlYnJ1YXJ5IDI4LCAyMDE0IDExOjI2IEFNLCBJYW4gQWJib3R0IDxhYmJvdHRpQG1ldi5jby51az4gd3IBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.177.636
References: <1393572936-9676-1-git-send-email-chase.southwood@yahoo.com> <5310C4CB.2060201@mev.co.uk> <1393652927.45628.YahooMailNeo@web164006.mail.gq1.yahoo.com> <1393733614.99805.YahooMailNeo@web164001.mail.gq1.yahoo.com> <53148E02.3060703@mev.co.uk>
Message-ID: <1393905983.58239.YahooMailNeo@web164001.mail.gq1.yahoo.com>
Date: Mon, 3 Mar 2014 20:06:23 -0800 (PST)
From: Chase Southwood <chase.southwood@yahoo.com>
Reply-To: Chase Southwood <chase.southwood@yahoo.com>
Subject: Re: [PATCH] Staging: comedi: add timeouts to while loops in s626.c
To: Ian Abbott <abbotti@mev.co.uk>, Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc: "hsweeten@visionengravers.com" <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <53148E02.3060703@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>On Monday, March 3, 2014 8:13 AM, Ian Abbott <abbotti@mev.co.uk> wrote:

>>On 2014-03-02 04:13, Chase Southwood wrote:
>>>On Friday, February 28, 2014 11:49 PM, Chase Southwood <chase.southwood@yahoo.com> wrote:
>>>> On Friday, February 28, 2014 11:26 AM, Ian Abbott <abbotti@mev.co.uk> wrote:
>>>>> On 2014-02-28 07:35, Chase Southwood wrote:
>>
>> [snip]
>>
>>>> In the case of s626_send_dac(), it doesn't seem to be used in any
>>>> critical sections, so it could make use of Hartley's comedi_timeout().
>>>>
>>>> Some of the timeout errors could be propagated, especially for
>>>> s626_send_dac() which is only reachable from very few paths.
>>>
>>>
>>> Awesome, I'll swap all of my timeouts out for comedi_timeout() in s626_send_dac().
>>
>> Actually, after taking another look at this, I don't think that using comedi_timeout()
>> here is going to work, actually.
>> The context from which s626_send_dac() is called allows sleep all right, but readl() isn't
>> a comedi function and therefore it doesn't behave (in parameters or return values) as
>> the callback function parameter to comedi_timeout() requires.  So unless I'm missing
>> something particularly large here, I believe we'll have to do the timeouts here manually
>> as well.  Am I correct here, and if so, would you like the iteration based timeouts here
>> as well, or a sleep-based timeout similar to that employed by comedi_timeout()?
>
>The readl() could be done in a small callback function.  As the 
>different while loops are checking for different results from readl(), 
>It would need a different callback functions for each case, or some 
>creative use of the callback function's 'context' parameter.
>

Oh, of course.  I'll see if there's a reasonably clear way that I can use the
context parameter to use a single callback, if not I'll just define a few of them.

I'll send a patch with the new callback(s), and the timeouts in s626_send_dac()
switched to comedi_timeout(), and I'll add the timeouts that were left out last
time, and then another patch or patchset propagating everything upwards.

Thanks,
Chase

>
>-- 
>-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
>-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
>--

