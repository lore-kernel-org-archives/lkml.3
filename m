Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216AbaAJAbK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 19:31:10 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:26969 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753499AbaAJAbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 19:31:07 -0500
X-AuditID: cbfee68e-b7f566d000002344-8d-52cf3f49b8c4
Message-id: <52CF3F49.1010709@samsung.com>
Date: Fri, 10 Jan 2014 09:31:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Jesper Falk <jesperfalk94@gmail.com>
Cc: anton@enomsg.org, dwmw2@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Power: charger-manager: Fixed coding style
References: <1389023175-11872-1-git-send-email-jesperfalk94@gmail.com>
 <52CF3F0B.8030006@samsung.com>
In-reply-to: <52CF3F0B.8030006@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsWyRsSkSNfL/nyQQWcDs8XBrZoWE1dOZrZo
	bF/IZHF51xw2BxaPCf2fGD12zrrL7rF5hZbH501yASxRXDYpqTmZZalF+nYJXBlz92xlKdjB
	UtF+6jJ7A+MJ5i5GTg4JAROJLbs+sEPYYhIX7q1nA7GFBJYySmxZrQlTM2HCNaYuRi6g+CJG
	ic0TOtghnFeMEs0bP7OCVPEKaEl8fDqTBcRmEVCVuPP1LFicDSi+/8UNsKmiAmESK6dfYYGo
	F5T4MfkemC0ioCGx8G83WD2zgLvE3safjCC2sIC9RMOORqiL0iVuPP3MBGJzCmhLbDvXyQZR
	ryOxv3UalC0vsXnNW2aQ4yQEVrFLLJ3XzQhxkIDEt8mHgJZxACVkJTYdgPpeUuLgihssExjF
	ZiE5aRaSsbOQjF3AyLyKUTS1ILmgOCm9yEivODG3uDQvXS85P3cTIzCWTv971reD8eYB60OM
	yUArJzJLiSbnA2MxryTe0NjMyMLUxNTYyNzSjDRhJXHeRQ+TgoD+TyxJzU5NLUgtii8qzUkt
	PsTIxMEp1cBoeTNr2gqT5GXuJ8OWKbpt316X8qIs/PBpr9JpThLSerMn/LMw1No3U+1wFPep
	XWtEnDcm1JyxnJUQKnLRTH36o5pJC64nhC1tae1PW7D0UcRdB6ZZ4dWGN4R1Uw6ddyl/bPT1
	0p9yfTMuxSvNnDsav2zj8UgIsarSl3JJab7p8snH2rmkJUGJpTgj0VCLuag4EQCz5CYuuwIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjleLIzCtJLcpLzFFi42I5/e+xgK6n/fkgg4frLC0ObtW0mLhyMrNF
	Y/tCJovLu+awObB4TOj/xOixc9Zddo/NK7Q8Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGHMmLtnK0vBDpaK9lOX2RsYTzB3MXJySAiYSEyYcI0JwhaTuHBvPVsX
	IxeHkMAiRonNEzrYIZxXjBLNGz+zglTxCmhJfHw6kwXEZhFQlbjz9SxYnA0ovv/FDTYQW1Qg
	TGLl9CssEPWCEj8m3wOzRQQ0JBb+7QarZxZwl9jb+JMRxBYWsJdo2NEI1iskkC5x4+lnsIs4
	BbQltp3rZIOo15HY3zoNypaX2LzmLfMERoFZSFbMQlI2C0nZAkbmVYyiqQXJBcVJ6blGesWJ
	ucWleel6yfm5mxjBsfpMegfjqgaLQ4wCHIxKPLwris8GCbEmlhVX5h5ilOBgVhLhTbM6HyTE
	m5JYWZValB9fVJqTWnyIMRkYAhOZpUST84FpJK8k3tDYxMzI0sjc0MLI2Jw0YSVx3oOt1oFA
	3yeWpGanphakFsFsYeLglGpg7CtgsYmNe7EsvDj7+/KTG+QifvRLnWCoOddSWTFjSXjmh9L+
	aXJBBq0lTSK5a6rsXnscWfRgZ+L7U/GKz//Gidosk3m2vXP5BTsBDefb6gutH0iLtOxlvNm0
	b2PwfYcKmamzip2Wse+8Xjqr8EPmgsaWE3euLrOQlsrmMdVfv0+nPetfQqqaEktxRqKhFnNR
	cSIArxTXgxkDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 09:30 AM, Chanwoo Choi wrote:
> On 01/07/2014 12:46 AM, Jesper Falk wrote:
>> Removed apaces before semicolon and fixed brackets on if statements
>>
>> Signed-off-by: Jesper Falk <jesperfalk94@gmail.com>
>> ---
>>  drivers/power/charger-manager.c | 19 ++++++++-----------
>>  1 file changed, 8 insertions(+), 11 deletions(-)
>>
> 
> Acked-by: Chanwoo Choi
> 
> I reviewed and tested this patch.
> 
> Thanks,
> Chanwoo Choi
> 
Sorry, I am missing email address.

Acked-by: Chanwoo Choi <cw00.choi@samsung.com>

Thanks,
Chanwoo Choi
