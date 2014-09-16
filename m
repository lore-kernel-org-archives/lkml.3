Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596AbaIPXiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:38:13 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:19466 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaIPXiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:38:12 -0400
X-AuditID: cbfee68d-f79c46d000000b84-1e-5418c9e1f520
Date: Tue, 16 Sep 2014 23:38:09 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] extcon: sm5502: Drop useless include
To: Jean Delvare <jdelvare@suse.de>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20140916233744702@myungjoo.ham
Msgkey: 20140916233744702@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20140916233744702@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <32259363.443141410910688801.JavaMail.weblogic@epml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsWyRsSkQPfhSYkQg+/75Swu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG16UTLAW3OCouz/3H1sC4g6OLkZNDSEBdYtGSk2wgtoSAicTD
	+auYIWwxiQv31rNB1CxllFjSaAFT8/v0KqYuRi6g+BxGiSu/N7KAJFgEVCUaLz4Gsjk42ATM
	Je7PCAIJCwtYAtXPAysREUiSaN3wggmkhFnAUGLuhxSI8UoSa/a9AivhFRCUODnzCdgUCaCJ
	W5clQ4TVJJ4cW8wEcYGExKzpF1ghbF6JGe1PWSBsOYlpX9dAXS8tcX7WBkaYTxZ/fwwV55c4
	dnsHE8R4Xokn94Nhxuze/AUaCAISU88chGrVkvi7/zc7hM0nsWbhWxaYMbtOLWeG6b2/ZS7Y
	acwCihJTuh+yQ9haEl9+7GND9RWI7STR0z+BdQKj8iwkqVlI2mchaUdWs4CRZRWjaGpBckFx
	UnqRoV5xYm5xaV66XnJ+7iZGYEI4/e9Z7w7G2wesDzEKcDAq8fB6PBIPEWJNLCuuzD3EaAqM
	oonMUqLJ+cC0k1cSb2hsZmRhamJqbGRuaaYkzqso9TNYSCA9sSQ1OzW1ILUovqg0J7X4ECMT
	B6dUA+MRK6VnkYy3VcKPp6xlNuFnmXlh976ZDp/tN19flqs14S8Tb7yl0nXdJbtqBZW2PWUy
	zJimdbLye7XHd8b7CRI3zn66GXQj6prOkny7lRosv/9n/fIqyA5oXL7k/XtNa9a004LSDScE
	Ns56ut5uprmToawkz4oLW8zjBNs6JUROnuWM1UiOeqPEUpyRaKjFXFScCACfCi2LAwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPKsWRmVeSWpSXmKPExsVy+t/tPt2HJyVCDHobJSwu75rD5sDo8XmT
	XABjVJpNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrShuZGekYGeqZGeoXGslaGBgZEpUE1CWkbX
	pRMsBbc4Ki7P/cfWwLiDo4uRk0NIQF1i0ZKTbCC2hICJxO/Tq5ggbDGJC/fWA8W5gGrmMEpc
	+b2RBSTBIqAq0XjxMZDNwcEmYC5xf0YQSFhYwBKodx5YiYhAkkTrhhdMICXMAoYScz+kQKxS
	kliz7xVYCa+AoMTJmU/ApkgATdy6LBkirCbx5NhiqAskJGZNv8AKYfNKzGh/ygJhy0lM+7qG
	GcKWljg/awMjzMWLvz+GivNLHLu9gwliPK/Ek/vBMGN2b/4C9ayAxNQzB6FatST+7v/NDmHz
	SaxZ+JYFZsyuU8uZYXrvb5kLdhqzgKLElO6H7BC2lsSXH/vYUH0FYjtJ9PRPYJ3AKDcLSWoW
	kvZZSNqR1SxgZFnFKJpakFxQnJReYahXnJhbXJqXrpecn7uJEZyYni3cwfjlvPUhRgEORiUe
	Xo9H4iFCrIllxZW5hxglOJiVRHh/+EqECPGmJFZWpRblxxeV5qQWH2I0BcbeRGYp0eR8YNLM
	K4k3NDY2MTMxtTSxMDA1VxLnvXszKUhIID2xJDU7NbUgtQimj4mDU6qBcb/huX3aCplpSzj0
	as+dUDEXEDriqRpz27+781Wb4F/2Fxx1rjqHxWYZBe1vnnNfffK7n4+m3sy4cGy2n/gZf7sz
	/y9la2Sb/4k4/FZlvV3owusNkQb1Z2bsqQhx/adyJ+Igx7dVC3xXJczav6/ufojK4ql2IlNq
	VRmntM7O/7Doi5lqhvqBK0osxRmJhlrMRcWJAAANqM1iAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8GNcIBd031292

> Don't include <linux/input.h> when the driver does not use anything
> from this header file.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>
> Cc: Chanwoo Choi <cw00.choi@samsung.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Chanwoo, please review/merge the patch when you return.

Cheers,
MyungJoo

> ---
>  drivers/extcon/extcon-sm5502.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> --- a/drivers/extcon/extcon-sm5502.c
> +++ b/drivers/extcon/extcon-sm5502.c
> @@ -17,7 +17,6 @@
>  
>  #include <linux/err.h>
>  #include <linux/i2c.h>
> -#include <linux/input.h>
>  #include <linux/interrupt.h>
>  #include <linux/irqdomain.h>
>  #include <linux/kernel.h>
> 
> -- 
> Jean Delvare
> SUSE L3 Support
> 
> 
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
