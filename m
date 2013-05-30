Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967721Ab3E3HGG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:06:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:37717 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967670Ab3E3HF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:05:57 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-1b-51a6fa53e2d5
From: Jingoo Han <jg1.han@samsung.com>
To: "'Tushar Behera'" <tushar.behera@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, "'Kevin Hilman'" <khilman@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Doug Anderson'" <dianders@chromium.org>,
        "'Patch Tracking'" <patches@linaro.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        Jingoo Han <jg1.han@samsung.com>
References: <1368168599-28507-1-git-send-email-tushar.behera@linaro.org>
 <87sj1qzaov.fsf@linaro.org> <5191AA89.6010901@linaro.org>
 <20130528231740.GA28879@quad.lixom.net> <51A57D39.8030506@linaro.org>
 <CAOesGMh50Dzr_jczHZC5_txfW=6a+7EgFKvgZgj9MhUcVUTJ1Q@mail.gmail.com>
 <51A5C16D.20408@linaro.org> <000001ce5c4f$839f4cb0$8adde610$@samsung.com>
 <CAOesGMiYs6GfaWGWYB8cw_cJ6_RmmZTb4oPfXo1PYJT8-jdHzw@mail.gmail.com>
 <51A6C97A.6030306@linaro.org>
In-reply-to: <51A6C97A.6030306@linaro.org>
Subject: Re: [PATCH] ARM: EXYNOS: Update defconfig for Arndale and Origen board
Date: Thu, 30 May 2013 16:05:54 +0900
Message-id: <000101ce5d04$20abb7a0$620326e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQIU7nTg5yYSnFMzgDE9nqE+1HD1bgFvVSYoAdTiqN8CaMaKbwMHW2GEAh1I9CECd4Dp0QIEycDEAco9bkQA0Asf35gA5qvg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupmleLIzCtJLcpLzFFi42I5/e+ZoW7wr2WBBps6+Sz+TjrGbnF22UE2
	i7YrB9ktLi+8xGrRu+Aqm8XXwysYLTY9vsZqcXnXHDaLGef3MVmcuv6ZzWLK4S8sFsdmLGG0
	aP+7l82B1+P3r0mMHrMbLrJ43Lm2h81j85J6jysnmlg9+rasYvT4vEkugD2KyyYlNSezLLVI
	3y6BK+PK3OesBV84K+5sOczawPiOvYuRk0NCwERi98d1ULaYxIV769m6GLk4hASWMUp8P7aP
	DaZo+ZZdzBCJ6YwSd7cfgar6xSjx68lhVpAqNgE1iS9fDoONEhEIljj48Q87SBGzwBpmia0T
	LjNBdBxjlpg46ShYFaeAlsT7YxOZQWxhAX+JG99nAdkcHCwCqhJ/24xAwrwClhLdS24zQ9iC
	Ej8m32MBsZmBWtfvPM4EYctLbF7zlhniVAWJHWdfM0IcUSBx69MUVogaEYl9L94xgtwgIbCQ
	Q6Kz+xjYbywCAhLfJh9iAdkrISArsekA1BxJiYMrbrBMYJSYhWT1LCSrZyFZPQvJigWMLKsY
	RVMLkguKk9KLDPWKE3OLS/PS9ZLzczcxQhJC7w7G2wesDzEmA62fyCwlmpwPTCh5JfGGxmZG
	FqYmpsZG5pZmpAkrifOqtVgHCgmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDcKf5i07SgL4eS
	1jJ3OT9t0dXXnxK5VGl7zowZ0yf91kntllW3OZll6yl2qfSsu/+t0n+XXX50Xdqr2G8RUPHq
	YJh4kE+xz8zcw6fO/pdsvTkpxar9geTPZSv+5z2/L6CygqtvVUttWrzhD5XQWRK6GkJam/JX
	VDc+SWpT61n/Nfk3+1Tdm3eVWIozEg21mIuKEwFhuHILHgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBKsWRmVeSWpSXmKPExsVy+t9jQd3gX8sCDdY/4bD4O+kYu8XZZQfZ
	LNquHGS3uLzwEqtF74KrbBZfD69gtNj0+BqrxeVdc9gsZpzfx2Rx6vpnNosph7+wWBybsYTR
	ov3vXjYHXo/fvyYxesxuuMjicefaHjaPzUvqPa6caGL16NuyitHj8ya5APaoBkabjNTElNQi
	hdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKBzlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZV+Y+Zy34wllxZ8th1gbGd+xdjJwcEgImEsu3
	7GKGsMUkLtxbz9bFyMUhJDCdUeLu9iNQzi9GiV9PDrOCVLEJqEl8+XIYrFtEIFji4Mc/7CBF
	zAJrmCW2TrjMBNFxjFli4qSjYFWcAloS749NBNshLOAvceP7LCCbg4NFQFXib5sRSJhXwFKi
	e8ltZghbUOLH5HssIDYzUOv6nceZIGx5ic1r3kKdqiCx4+xrRogjCiRufZrCClEjIrHvxTvG
	CYxCs5CMmoVk1Cwko2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjdPJPewbiq
	weIQowAHoxIPL6fuskAh1sSy4srcQ4wSHMxKIrx1H4FCvCmJlVWpRfnxRaU5qcWHGJOBHp3I
	LCWanA9MhXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5stQ4UEkhPLEnNTk0tSC2C2cLEwSnVwGgX
	47n9j6znfL3ZC6a1bSmbU7Y/y0LwTUxprP6vRMHv3NOmmJ7cLtOnm/LLQ2BX/7lHPa2RISq7
	lrWsz7KQOK9l/1G/PmyF3+S6UNE/u36XXPQOfvNB5kvx7UguEwaJciUz9xInsxP7ni5YUhV4
	4FOE6WkXb3GOCr32Mi8DvVjRNzMFjTo0lViKMxINtZiLihMB2SZUiXsDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 30, 2013 12:38 PM, Tushar Behera wrote:
>On 05/30/2013 12:16 AM, Olof Johansson wrote:
>> On Wed, May 29, 2013 at 2:33 AM, Jingoo Han <jg1.han@samsung.com> wrote:
>>
>>> However, Olof Johansson mentioned, 'drivers/platform/arm/board_arndale.c'
>>> would be a good alternative.
>>
>>
>> Whoa. I didn't quite realize what I proposed, or rather, how what I
>> proposed could be perceived. I take it back. :)

My original message is as below.

"However, as Olof Johansson mentioned, 'drivers/platform/arm/'
would be a good alternative."

Also, 'board_arndale.c' should not be mentioned.
Sorry for making confusion. :)

>>
>> We must _not_ introduce something that will be abused as a new home
>> for board file junk. If we do introduce a platform glue directory it
>> would need to be very limited in scope. Compare to what's in
>> drivers/platform/x86 today.
>>
>>
>> -Olof
>>
>
>This was my proof-of-concept for moving USB hub reset code out of USB
>driver. Verified that it works.

Thank you for your additional comment.

>
>I would wait for your patches for wifi-reset sequence and then will add
>hub-reset code for Arndale.

Yes, this way looks good.

Best regards,
Jingoo Han

>
>
>--
>Tushar Behera

