Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3CSK3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 06:29:14 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:50616 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab3CSK3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 06:29:12 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-44-51483df3200c
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <000101ce2462$e31b5fa0$a9521ee0$%han@samsung.com>
 <000201ce2463$06750e60$135f2b20$%han@samsung.com>
 <514833A6.5010502@samsung.com>
In-reply-to: <514833A6.5010502@samsung.com>
Subject: RE: [PATCH v2 2/2] extcon: max8997: add missing const
Date: Tue, 19 Mar 2013 19:29:07 +0900
Message-id: <001901ce248c$9655f480$c301dd80$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4khnGTRCVIpN+BQ2CEtvcNgekT+gABeu/g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zfd3Pth6BBsfmW1pc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmKyyYlNSezLLVI3y6BK+PHhFbmgleCFevfnmBuYJzE
	18XIwSEhYCJxfGZWFyMnkCkmceHeerYuRi4OIYFljBLPHixkhkiYSNy9cYEJIjGdUeJ6+2RG
	COcXo8SMNysZQarYBNQkvnw5zA5iiwhoSUzsnMkEYjMLFErcvjGXFaJhEqPEyVPXWEBWcwpo
	S7zaZwRSIyxgJ7Hi5wWwXhYBVYlzc16CzeQVsJVYO2sPK4QtKPFj8j0WiJlaEut3HoeaLy+x
	ec1bZohv1CUe/dWFOMFIovfhLkaIEhGJfS/egd0sIbCPXeLFsw5WiF0CEt8mH2KB6JWV2HQA
	6mFJiYMrbrBMYJSYhWTzLCSbZyHZPAvJigWMLKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcx
	QiJw4g7G+wesDzEmA62fyCwlmpwPjOC8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tS
	s1NTC1KL4otKc1KLDzEycXBKNTC2Kr6d/PY6Q0gS774bUt9LbvccfbJineOEK/s4m1/McvOa
	5Mc6j/ONxpcw/aZ/ujPzgxiWPa5vfrDqnLDD7Dm6Oo4ihdMXKKTPcnvO/6DigMb1qJgDKtYL
	cw6ePr7MPUt0DdPFJWmifmw2/e+iXQ7mV9WtyLc6lSq2r8NhZ8359WIG9/8e+MiqxFKckWio
	xVxUnAgALHSbRNYCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrIKsWRmVeSWpSXmKPExsVy+t9jQd3Pth6BBpO/mVhc//Kc1eLywktA
	YtccNovbjSvYHFg8+rasYvT4vEkugCmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX
	0NLCXEkhLzE31VbJxSdA1y0zB2iTkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMD
	NJCwjjHjx4RW5oJXghXr355gbmCcxNfFyMkhIWAicffGBSYIW0ziwr31bF2MXBxCAtMZJa63
	T2aEcH4xSsx4s5IRpIpNQE3iy5fD7CC2iICWxMTOmWDdzAKFErdvzGWFaJjEKHHy1DWWLkYO
	Dk4BbYlX+4xAaoQF7CRW/LwA1ssioCpxbs5LsJm8ArYSa2ftYYWwBSV+TL7HAjFTS2L9zuNQ
	8+UlNq95ywwyUkJAXeLRX12IE4wkeh/uYoQoEZHY9+Id4wRGoVlIJs1CMmkWkkmzkLQsYGRZ
	xSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc4c+kdzCuarA4xCjAwajEw6sQ5h4oxJpYVlyZ
	e4hRgoNZSYR3lb5HoBBvSmJlVWpRfnxRaU5q8SHGZKBHJzJLiSbnA5NPXkm8obGJmZGlkZmF
	kYm5OWnCSuK8B1utA4UE0hNLUrNTUwtSi2C2MHFwSjUwivLHywukP4r9onAu1pbtwGl16+ML
	b05acH7vu38ta6rUVpxjjzbnd2HReD3vyRTRI2q6P3d5zr6sLfto3dNHBk0dOimP7qaKJR27
	+23au0bx6sr/5VKTgiZav/vJfbfgccfB9v9NXRuLKqfNFN1qVvGxZM7j5edNxR9IfOz+Z8rK
	ITv5H/eexUosxRmJhlrMRcWJALzY0KQ0AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 19, 2013 6:45 PM, Chanwoo Choi wrote:
> 
> On 03/19/2013 02:31 PM, Jingoo Han wrote:
> > Fixed the checkpatch warning as below:
> >
> >   WARNING: static const char * array should probably be static const char * const
> >   #163: FILE: drivers/extcon/extcon-max8997.c:163:
> >   +static const char *max8997_extcon_cable[] = {
> >
> > Also, const is added to variable 'supported_cable' to prevent
> > build warning as below:
> >
> >   drivers/extcon/extcon-max8997.c: In function 'max8997_muic_probe':
> >   drivers/extcon/extcon-max8997.c:708:30: warning: assignment discards 'const' qualifier from pointer
> target type [enabled by
> > default]
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > ---
> > Changes since v1:
> > - Added const to variable 'supported_cable'
> >
> >  drivers/extcon/extcon-max8997.c |    2 +-
> >  include/linux/extcon.h          |    2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
> > index 20772ad..b82a591 100644
> > --- a/drivers/extcon/extcon-max8997.c
> > +++ b/drivers/extcon/extcon-max8997.c
> > @@ -160,7 +160,7 @@ enum {
> >  	_EXTCON_CABLE_NUM,
> >  };
> >
> > -static const char *max8997_extcon_cable[] = {
> > +static const char * const max8997_extcon_cable[] = {
> OK.
> >  	[EXTCON_CABLE_USB]			= "USB",
> >  	[EXTCON_CABLE_USB_HOST]			= "USB-Host",
> >  	[EXTCON_CABLE_TA]			= "TA",
> > diff --git a/include/linux/extcon.h b/include/linux/extcon.h
> > index fcb51c8..741a491 100644
> > --- a/include/linux/extcon.h
> > +++ b/include/linux/extcon.h
> > @@ -113,7 +113,7 @@ struct extcon_cable;
> >  struct extcon_dev {
> >  	/* --- Optional user initializing data --- */
> >  	const char	*name;
> > -	const char **supported_cable;
> > +	const char * const *supported_cable;
> I understand your intention to fix build warning.
> But, I don't agree this coding style. I think this coding
> style is not general method.

Um, how about the following?
In this case, there is no build warning and checkpatch warning.

-static const char *max8997_extcon_cable[] = {
+static char const *max8997_extcon_cable[] = {


> 
> Thanks,
> Chanwoo Choi
> 
> 


