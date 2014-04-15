Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862AbaDOAoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 20:44:21 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:57861 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942AbaDOAoT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 20:44:19 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-9a-534c80e1fdf7
From: Jingoo Han <jg1.han@samsung.com>
To: "'Pascal COMBES'" <pascom@orange.fr>, "'Paul Bolle'" <pebolle@tiscali.nl>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        "'Peter P Waskiewicz Jr'" <peter.p.waskiewicz.jr@intel.com>,
        "'Jarod Wilson'" <jarod@wilsonet.com>,
        "'Valentina Manea'" <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, "'Naren Sankar'" <nsankar@broadcom.com>,
        "'Monam Agarwal'" <monamagarwal123@gmail.com>,
        "'Scott Davilla'" <davilla@4pi.com>,
        "'Amarjargal Gundjalam'" <amarjargal16@gmail.com>,
        "'Dan Carpenter'" <dan.carpenter@oracle.com>,
        "'Robert Foss'" <dev@robertfoss.se>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>
 <534AE1D6.1040304@orange.fr> <1397424990.31896.10.camel@x220>
 <534C0EE3.6080308@orange.fr>
In-reply-to: <534C0EE3.6080308@orange.fr>
Subject: Re: [PATCH v2 2/3] Fix coding style problem (cast with space) in
 drivers/staging/crystalhd/crystalhd_lnx.c
Date: Tue, 15 Apr 2014 09:44:17 +0900
Message-id: <008401cf5843$d4ce80b0$7e6b8210$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9X/+i87oRtc3U0T4uK0o1AXJTVVQAQ44Gg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAKsWRmVeSWpSXmKPExsVy+t8zY92HDT7BBn+fG1pMenaVyeL1v+ks
	FrNerWK02HdtHrPFnjO/2C2aF69ns7j64gSTxeWFl1gtLu+aw2bR/HsDo8XRU7vZLJ49PMhq
	sejWGWaLN/t2sli8uzSX3YHfY8Gz8+wes+6fZfO4t+8wi8fOWXfZPRbvecnksX/uGnaPj09v
	sXg8X7yExePqokdMHn1bVjF6bNz+hMnj8yY5j6kn+1gDeKO4bFJSczLLUov07RK4MvrPfGMt
	2MBb8endHpYGxptcXYycHBICJhIHOx+zQ9hiEhfurWfrYuTiEBJYxigx5fBRdpiivzNvMEMk
	pjNKTN67Esr5zSix8OYkJpAqNgE1iS9fDgN1cHCICHhKfPnmABJmFljPItE1SQmifhWjxJ8d
	x9hAEpwCmhJrP3Qwg9jCAqUSfz5+BJvDIqAqse9MKwuIzStgK/HxwFNWCFtQ4sfkeywQQ3Uk
	9rdOY4OwtSWevLvACrJXQkBd4tFfXYgTjCTurhCAqBCR2PfiHSPEL084JLYvdIHYJCDxbfIh
	FohOWYlNB5ghSiQlDq64wTKBUWIWkr2zkOydhWTvLCQbFjCyrGIUTS1ILihOSi8y1StOzC0u
	zUvXS87P3cQISS0TdzDeP2B9iDEZaP1EZinR5HxgasoriTc0NjOyMDUxNTYytzQjTVhJnDf9
	UVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkbFaVEO87mffZtl3CXae+n/qt+Zm9zrnZ5X
	uWpXbLXbzMTWKHr+5xHOTYwW0qL107+nTYno/XfY0n9n0IbzafMqYk1iRGIDMy9P05jje4HL
	8K7dHAW7fAGPe1PO7f5a6fgqZNJj37d3n9xx8TdZPXnJFRPpFRLyM1TKrgf1LzlybYqXRcbD
	cHklluKMREMt5qLiRAB77XqsQwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjk+LIzCtJLcpLzFFi42I5/e+xoO7DBp9gg0erdCwmPbvKZPH633QW
	i1mvVjFa7Ls2j9liz5lf7BbNi9ezWVx9cYLJ4vLCS6wWl3fNYbNo/r2B0eLoqd1sFs8eHmS1
	WHTrDLPFm307WSzeXZrL7sDvseDZeXaPWffPsnnc23eYxWPnrLvsHov3vGTy2D93DbvHx6e3
	WDyeL17C4nF10SMmj74tqxg9Nm5/wuTxeZOcx9STfawBvFENjDYZqYkpqUUKqXnJ+SmZeem2
	St7B8c7xpmYGhrqGlhbmSgp5ibmptkouPgG6bpk5QH8pKZQl5pQChQISi4uV9O0wTQgNcdO1
	gGmM0PUNCYLrMTJAAwnrGDP6z3xjLdjAW/Hp3R6WBsabXF2MnBwSAiYSf2feYIawxSQu3FvP
	1sXIxSEkMJ1RYvLelcwQzm9GiYU3JzGBVLEJqEl8+XKYvYuRg0NEwFPiyzcHkDCzwHoWia5J
	ShD1qxgl/uw4xgaS4BTQlFj7oQNsg7BAqcSfjx/B5rAIqErsO9PKAmLzCthKfDzwlBXCFpT4
	MfkeC8RQHYn9rdPYIGxtiSfvLrCC7JUQUJd49FcX4gQjibsrBCAqRCT2vXjHOIFRaBaSQbOQ
	DJqFZNAsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl5+duYgSnrmdSOxhXNlgcYhTgYFTi
	4Z3wzjtYiDWxrLgy9xCjBAezkgjv62SfYCHelMTKqtSi/Pii0pzU4kOMyUB/TmSWEk3OB6bV
	vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJpCeWpGanphakFsFsYeLglGpglN99TN/Oc/86
	50MLVA1EpFdP+hp52iTR7gHDBPbMz5Wf3W3Y6gze2Xy/1nI/XKa+Yuf7XhbnJy/3syz8+bMo
	vEp8+w/pqyVRCXsfBO66q97uP6cqfW7429aLx+ZtmB/4lU83t8jiEvPzd0rf/fnXXfK1s7kX
	WrbkZsuWJVZyRtMflgka/rtYrcRSnJFoqMVcVJwIAOvcPEGhAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 15, 2014 1:38 AM, Pascal COMBES wrote:
> 
> Le 13/04/2014 23:36, Paul Bolle a écrit :
> > On Sun, 2014-04-13 at 21:13 +0200, Pascal COMBES wrote:
> >> From: Pascal COMBES <pascom@orange.fr>
> >>
> >> Fix coding style problem in drivers/staging/crystalhd/crystalhd_lnx.c:
> >> No space needed before a cast.
> >>
> >> Signed-off-by: Pascal COMBES <pascom@orange.fr>
> >> ---
> >> diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
> >> index fd7f08a..15e8f02 100644
> >> --- a/drivers/staging/crystalhd/crystalhd_lnx.c
> >> +++ b/drivers/staging/crystalhd/crystalhd_lnx.c
> >> @@ -28,7 +28,7 @@ static struct crystalhd_adp *g_adp_info;
> >>
> >>  static irqreturn_t chd_dec_isr(int irq, void *arg)
> >>  {
> >> -	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
> >> +	struct crystalhd_adp *adp = (struct crystalhd_adp *)arg;
> >
> > Shouldn't this cast just be dropped instead?
> 
> I think as you and was wondering why it was there but I didn't dare
> removing it. I considered it was not really coding style.
> But after second thought, I will remove it when I resend tomrorrow.

Please, remove unnecessary void cast as below.

 -	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
 +	struct crystalhd_adp *adp = arg;

This is because the conversion from void pointer to any other
pointer type is guaranteed by the C programming language.
So, void cast is unnecessary.

Best regards,
Jingoo Han

> 	Regards,
> Pascal COMBES.
> >
> >>  	int rc = 0;
> >>  	if (adp)
> >>  		rc = crystalhd_cmd_interrupt(&adp->cmds);
> >>
> >
> >
> > Paul Bolle
> >
> >

