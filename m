Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056Ab3CSDhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:37:34 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:33684 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564Ab3CSDhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:37:32 -0400
X-AuditID: cbfee690-b7f656d0000007e3-86-5147dd7b393b
From: Jingoo Han <jg1.han@samsung.com>
To: "'Sachin Kamat'" <sachin.kamat@linaro.org>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000001ce2445$e1927be0$a4b773a0$%han@samsung.com>
 <000101ce2445$f61b7120$e2525360$%han@samsung.com>
 <CAK9yfHxMf8+Kb6qup70M+iOGznH6AVgKMRf8+xXa757oxQZdQQ@mail.gmail.com>
In-reply-to: <CAK9yfHxMf8+Kb6qup70M+iOGznH6AVgKMRf8+xXa757oxQZdQQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] extcon: max8997: add missing const
Date: Tue, 19 Mar 2013 12:37:30 +0900
Message-id: <000001ce2453$15eafbd0$41c0f370$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4kUoW9lTeponVNQAy8Ti22ZQu2PgAAFNGg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zI93qu+6BBh/Xcllc//Kc1eLywktA
	YtccNovbjSvYLE7+6WV0YPW4c20Pm0ffllWMHp83yQUwR3HZpKTmZJalFunbJXBlzJ96ia3g
	DXfF418bmBoY93B2MXJySAiYSFyb38YOYYtJXLi3ng3EFhJYxijx80ssTM3N6TcYuxi5gOLT
	GSWOH+xjhnB+MUq8eb0FrJtNQE3iy5fDYLaIgI7Eil1rmUCKmAVmM0q837iNDaJjB6PEjZ9X
	wao4BYIlJq7ZzgxiCwtYS5x8eIsVxGYRUJX43rwBzOYVsJW4vmMNlC0o8WPyPRYQm1lAS2L9
	zuNMELa8xOY1b4HmcADdqi7x6K8uxBFGEsv63rBClIhI7HvxjhHinVPsEvOmpEGsEpD4NvkQ
	C0SrrMSmA8wQJZISB1fcYJnAKDELyeJZSBbPQrJ4FpINCxhZVjGKphYkFxQnpReZ6BUn5haX
	5qXrJefnbmKExOWEHYz3DlgfYkwGWj+RWUo0OR8Y13kl8YbGZkYWpiamxkbmlmakCSuJ86q3
	WAcKCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYPS91Pgg0+j5yqU34hU1Q3ZMf+Cgc/Tdntaz
	d/64XZ67yedpitHz549Xnl1zRPLbSlXt++FP78rzLypNCqzcc9f/guaXXzPuqWn83dfmsnN/
	RDZHb+HifbHHePvq5O5tOjVjSXU/x2E7nvlfp6x/lbwn+hxv5upNT5epxdUf+h2QodF7OXNz
	SrKaEktxRqKhFnNRcSIARUo+aOECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrLKsWRmVeSWpSXmKPExsVy+t9jQd3qu+6BBrPesFpc//Kc1eLywktA
	YtccNovbjSvYLE7+6WV0YPW4c20Pm0ffllWMHp83yQUwRzUw2mSkJqakFimk5iXnp2Tmpdsq
	eQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYA7VRSKEvMKQUKBSQWFyvp22GaEBripmsB
	0xih6xsSBNdjZIAGEtYxZsyfeomt4A13xeNfG5gaGPdwdjFyckgImEjcnH6DEcIWk7hwbz1b
	FyMXh5DAdEaJ4wf7mCGcX4wSb15vYQepYhNQk/jy5TCYLSKgI7Fi11omkCJmgdmMEu83boNq
	38EocePnVbAqToFgiYlrtjOD2MIC1hInH95iBbFZBFQlvjdvALN5BWwlru9YA2ULSvyYfI8F
	xGYW0JJYv/M4E4QtL7F5zVugORxAt6pLPPqrC3GEkcSyvjesECUiEvtevGOcwCg0C8mkWUgm
	zUIyaRaSlgWMLKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgiP/mdQOxpUNFocYBTgYlXh4
	TwS7BwqxJpYVV+YeYpTgYFYS4Q32BwrxpiRWVqUW5ccXleakFh9iTAZ6dCKzlGhyPjAp5ZXE
	GxqbmBlZGplZGJmYm5MmrCTOe6DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo1yXcLB3U1fWwojf
	569Kr3p6+4Vr5Z4988O8wz/eC5wq/v3n608lQUUalhKpKef/MsYJvXAT1ZE1nrBNrfyt433l
	ePbO7TNOHLn866lIl6Lgsuxvp9Jc+aP+M9zhZuGzkMme3uWi3pvSnaa5PTf1et3ly6LVzPcf
	/JOfc8pFeo5IykGHiWFvlViKMxINtZiLihMBRQ3QT0ADAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Sachin Kamat [mailto:sachin.kamat@linaro.org]
> Sent: Tuesday, March 19, 2013 12:33 PM
> To: Jingoo Han
> Cc: MyungJoo Ham; Chanwoo Choi; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH 2/2] extcon: max8997: add missing const
> 
> On 19 March 2013 07:33, Jingoo Han <jg1.han@samsung.com> wrote:
> > Fixed the checkpatch warning as below:
> >
> >   WARNING: static const char * array should probably be static const char * const
> >   #163: FILE: drivers/extcon/extcon-max8997.c:163:
> >   +static const char *max8997_extcon_cable[] = {
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> >  drivers/extcon/extcon-max8997.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> > index 20772ad..6e8724f 100644
> > --- a/drivers/extcon/extcon-max8997.c
> > +++ b/drivers/extcon/extcon-max8997.c
> > @@ -160,7 +160,7 @@ enum {
> >         _EXTCON_CABLE_NUM,
> >  };
> >
> > -static const char *max8997_extcon_cable[] = {
> > +static const char const *max8997_extcon_cable[] = {
> 
> Shouldn't this be "static const char * const max8997_extcon_cable[]"
> as suggested by checkpatch (as mentioned in your commit log)?

Hi Sachin Kamat,

Although the checkpatch warning is already fixed, I will send v2 patch
for clarity.

Thank you for your comment.

Best regards,
Jingoo Han

> 
> 
> --
> With warm regards,
> Sachin

