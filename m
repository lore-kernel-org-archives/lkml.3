Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaDVE5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 00:57:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27614 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaDVE5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 00:57:07 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-0b-5355f6a19b3b
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
        "'Chris Ball'" <chris@printf.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Ulf Hansson'" <ulf.hansson@linaro.org>
References: <20140422130655.51daec1807bde98ade65d691@canb.auug.org.au>
In-reply-to: <20140422130655.51daec1807bde98ade65d691@canb.auug.org.au>
Subject: RE: linux-next: build failure after merge of the mmc tree
Date: Tue, 22 Apr 2014 13:57:04 +0900
Message-id: <001001cf5de7$4e3728a0$eaa579e0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9d1/Zh+FrQNhxHR5+B4kcq66XxrwADY0PA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsVy+t8zA92F30KDDW6cZrGYcHk7o8WNX22s
	Fpd3zWGzOLiwjdFi696r7BbH14Y7sHk03rjB5nHn2h42jxuvFjJ59G1ZxejxeZNcAGsUl01K
	ak5mWWqRvl0CV8bVE1dYClZzVTyasI6pgXEDRxcjJ4eEgInE7P52ZghbTOLCvfVsXYxcHEIC
	yxgl9v26xwJTdPbDASaIxCJGid9n/rFDOH8YJdYvvMMKUsUmoCXx980bsFEiAn4SD5d1MIMU
	MQtMYpQ49mot2CghATeJj09vgDVwCrhLHPpxjRHEFhZwkjjz6zJQnIODRUBV4sczFZAwr4Ct
	xO2Xa9khbEGJH5MhLmIW0JP4+Oc2I4QtL7F5zVtmkFYJAXWJR391IU4wklj8diVUiYjEvhfv
	GEHOkRB4xC6x8t4ysDtZBAQkvk0+xALRKyux6QA0JCQlDq64wTKBUWIWks2zkGyehWTzLCQr
	FjCyrGIUTS1ILihOSi8y1StOzC0uzUvXS87P3cQIidmJOxjvH7A+xJgMtH4is5Rocj4w5vNK
	4g2NzYwsTE1MjY3MLc1IE1YS501/lBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgTHVQPhc
	444vlol7+8s3MRmpnVRenHolfmXg+cQ0hTkW5d+dgtNOvuuW+/TJf0HcxAMlnXtepHM/Fl1s
	/T13xYyFXmoqPQu70s1+SH2XeSmyaWvFxF38e+eXr377iH/jkmqjN5UnP03S8AtdoXh9zZEy
	t7L5L7d8O3ReYd3pxDwnRWFuFcvSidZKLMUZiYZazEXFiQAmvWVC7wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBKsWRmVeSWpSXmKPExsVy+t9jAd2F30KDDZqsLCZc3s5oceNXG6vF
	5V1z2CwOLmxjtNi69yq7xfG14Q5sHo03brB53Lm2h83jxquFTB59W1YxenzeJBfAGtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePqiSssBau5Kh5NWMfUwLiBo4uRk0NC
	wETi7IcDTBC2mMSFe+vZuhi5OIQEFjFK/D7zjx3C+cMosX7hHVaQKjYBLYm/b94wg9giAn4S
	D5d1MIMUMQtMYpQ49motC0hCSMBN4uPTG2ANnALuEod+XGMEsYUFnCTO/LoMFOfgYBFQlfjx
	TAUkzCtgK3H75Vp2CFtQ4sfke2BjmAX0JD7+uc0IYctLbF7zlhmkVUJAXeLRX12IE4wkFr9d
	CVUiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cT
	IzgdPJPawbiyweIQowAHoxIPr4RBaLAQa2JZcWXuIUYJDmYlEd57D4BCvCmJlVWpRfnxRaU5
	qcWHGJOB/pzILCWanA9MVXkl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C
	2cLEwSnVwJjKbK2/8bat47rfm2Z3reMKdfXY9H3lktzM050Z0TwO/A5Sq0wTJiW5n1BuW77x
	/a3C75mXkhsvcM0IilGMFb5oscDqys0ft/nLEmb9/FHgcVDFrqDoZMxuG6YgZjXt5cwV6dMX
	HNrNb3rWw/eFvH3ZQlsm1ZxWxgOXK+UjFY9VnT/wSDtFWImlOCPRUIu5qDgRAFKNQcVLAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, April 22, 2014, Stephen Rothwell wrote:
> Hi Chris,
> 
> After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/net/wireless/rsi/rsi_91x_sdio.c: In function 'rsi_reset_card':
> drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: error: 'MMC_STATE_HIGHSPEED' undeclared (first use in
> this function)
>     card->state &= ~MMC_STATE_HIGHSPEED;
>                     ^
> drivers/net/wireless/rsi/rsi_91x_sdio.c:288:20: note: each undeclared identifier is reported only once
> for each function it appears in
> drivers/net/wireless/rsi/rsi_91x_sdio.c:299:4: error: implicit declaration of function
> 'mmc_card_set_highspeed' [-Werror=implicit-function-declaration]
>     mmc_card_set_highspeed(card);
>     ^
> drivers/net/wireless/rsi/rsi_91x_sdio.c:306:2: error: implicit declaration of function
> 'mmc_card_highspeed' [-Werror=implicit-function-declaration]
>   if (mmc_card_highspeed(card))
>   ^
> 
> Caused by commit 395784826a81 ("mmc: drop the speed mode of card's state").
> 
> I have used the version of the mmc tree from next-20140417 for today.

I didn't detect usage out of mmc-sub for that.
Let me fix and send a patch.

Thanks,
Seungwon Jeon

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au

