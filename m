Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaBKMS7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:18:59 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:8923 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaBKMS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:18:56 -0500
X-AuditID: cbfee68f-b7f156d00000276c-0a-52fa152ea6c1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>
Cc: "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003901cf25fc$73002790$590076b0$%han@samsung.com>
 <003f01cf25fd$b3e274b0$1ba75e10$%han@samsung.com> <52FA12D1.4020408@metafoo.de>
In-reply-to: <52FA12D1.4020408@metafoo.de>
Subject: Re: [PATCH 6/7] Input: pwm-beepe: remove HAVE_PWM dependencies
Date: Tue, 11 Feb 2014 21:18:54 +0900
Message-id: <000901cf2723$6e68bc10$4b3a3430$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac8nIgHSf0sRpC3AS8mOGgsbgZGqfAAAVD5A
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zI1190V9BBteVLQ4vesFocXnhJVaL
	JZPns1rc/PSN1eLyrjlsDqweO2fdZfdY8uYQq0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	nD67nalgHVfFjfs/mBsYp3N0MXJySAiYSMzqncYIYYtJXLi3nq2LkYtDSGAZo8T2Bz1sMEWH
	T95lhkgsYpTo/PgVyvnFKDHp/01WkCo2ATWJL18Os4PYIgJaElO/vWUFKWIWmMIo0TDzHDtE
	Rz+jxIc1J4AyHBycQFVn38aCNAgLuEscPt3AAmKzCKhKrFy1jwnE5hWwlWj4f54dwhaU+DH5
	HlgNM1Dr+p3HmSBseYnNa94yg4yUEFCXePRXF+IGI4mFi64yQpSISOx78Y4R5AQJgVvsEndO
	dLBC7BKQ+Db5EAtEr6zEpgPMEB9LShxccYNlAqPELCSbZyHZPAvJ5llIVixgZFnFKJpakFxQ
	nJReZKxXnJhbXJqXrpecn7uJERKh/TsY7x6wPsSYDLR+IrOUaHI+MMLzSuINjc2MLExNTI2N
	zC3NSBNWEue9/zApSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVANjSq7UovipvjMjH6twVcg9
	fc5qoOelXjQ/6pVdVBNzlVfPmXOT5rW5TA2cFJRzpbCeffOyr3Vxm+TvnlxzQlmaL3zH4VVv
	9D9/OhAoYdKrJZmkvaXu7lm/8sRaliqlb0tnr4w6/P/y7oCnar1am2QXcurffzTln1LaSb3i
	5zaaJXkW6Q8XuDYrsRRnJBpqMRcVJwIAi8d4IeYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIKsWRmVeSWpSXmKPExsVy+t9jAV090V9BBjcWW1ocXvSC0eLywkus
	Fksmz2e1uPnpG6vF5V1z2BxYPXbOusvuseTNIVaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsY8w4fXY7U8E6roob938wNzBO5+hi5OSQEDCROHzyLjOE
	LSZx4d56ti5GLg4hgUWMEp0fvzJDOL8YJSb9v8kKUsUmoCbx5cthdhBbREBLYuq3t6wgRcwC
	UxglGmaeY4fo6GeU+LDmBFCGg4MTqOrs21iQBmEBd4nDpxtYQGwWAVWJlav2MYHYvAK2Eg3/
	z7ND2IISPybfA6thBmpdv/M4E4QtL7F5zVtmkJESAuoSj/7qQtxgJLFw0VVGiBIRiX0v3jFO
	YBSahWTSLCSTZiGZNAtJywJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQngmfQOxlUN
	FocYBTgYlXh4L3z6ESTEmlhWXJl7iFGCg1lJhHcjy68gId6UxMqq1KL8+KLSnNTiQ4zJQI9O
	ZJYSTc4HJqe8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamBc
	LfPs5r6uUGuLuoa2RdJtS24fnN+1Jt+zfBHjq0Z+oyt7f2leLnknNHeh5p3MnfNiv628b/Hi
	dZ+8etpFV5G6VUtUF/8L8o0/rfXb8FpM+t3HNxLZFv0puv/4+uw1xru2TPMV8JGSen7sangc
	8zupzAiVErbjqYdd5U7zeN6d8+iEUnTZr+8cSizFGYmGWsxFxYkAOLz0M0QDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 11, 2014 9:09 PM, Lars-Peter Clausen wrote:
> On 02/10/2014 02:16 AM, Jingoo Han wrote:
> > The HAVE_PWM symbol is only for legacy platforms that provide
> > the PWM API without using the generic framework. However, legacy
> > PWM drivers were already moved to the generic PWM framework.
> > Thus, HAVE_PWM should be removed, because HAVE_PWM is not
> > required anymore.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> 
> Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Hi Lars-Peter Clausen,

I really appreciate your Acked-by. However, the same patch was
already submitted by Sascha Hauer.[1] So, please ignore this patch.
Thank you.

[1] https://lkml.org/lkml/2014/1/16/262

Best regards,
Jingoo Han

> 
> > ---
> >   drivers/input/misc/Kconfig |    2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> > index ae74df7..762e6d2 100644
> > --- a/drivers/input/misc/Kconfig
> > +++ b/drivers/input/misc/Kconfig
> > @@ -470,7 +470,7 @@ config INPUT_PCF8574
> >
> >   config INPUT_PWM_BEEPER
> >   	tristate "PWM beeper support"
> > -	depends on PWM && HAVE_PWM
> > +	depends on PWM
> >   	help
> >   	  Say Y here to get support for PWM based beeper devices.
> >
> >

